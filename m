Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXDWQTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXDWQTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXDWQTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:19:54 -0400
Received: from ldap.somanetworks.com ([216.126.67.42]:50281 "EHLO
	mail.somanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbXDWQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:19:53 -0400
Date: Mon, 23 Apr 2007 12:19:40 -0400 (EDT)
From: Scott Murray <scottm@somanetworks.com>
X-X-Sender: scottm@rancor.yyz.somanetworks.com
To: Christoph Hellwig <hch@infradead.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpci_hotplug: Convert to use the kthread API
In-Reply-To: <20070422120534.GA20763@infradead.org>
Message-ID: <Pine.LNX.4.64.0704231210320.3671@rancor.yyz.somanetworks.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
 <11769657702107-git-send-email-ebiederm@xmission.com> <20070422120534.GA20763@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, Christoph Hellwig wrote:

> On Thu, Apr 19, 2007 at 12:55:29AM -0600, Eric W. Biederman wrote:
> > From: Eric W. Biederman <ebiederm@xmission.com> - unquoted
> > 
> > kthread_run replaces the kernel_thread and  daemonize calls
> > during thread startup.
> > 
> > Calls to signal_pending were also removed as it is currently
> > impossible for the cpci_hotplug thread to receive signals.
> 
> This drivers thread are a bit of a miss, although a lot better than
> most other pci hotplug drivers :)

Heh, I guess I'll take that as a compliment. :)
 
> Below is more complete conversion to the kthread infrastructure +
> wake_up_process to wake the thread.  Note that we had to keep
> a thread_finished variable because the existing one had dual use.
[snip]

I'm out of the office today, but I'll give it a spin on a test setup 
tomorrow.

Thanks,

Scott


-- 
Scott Murray
SOMA Networks, Inc.
Toronto, Ontario
e-mail: scottm@somanetworks.com
