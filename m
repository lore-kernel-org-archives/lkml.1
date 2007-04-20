Return-Path: <linux-kernel-owner+w=401wt.eu-S1422996AbXDTGXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422996AbXDTGXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422997AbXDTGXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:23:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32994 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422996AbXDTGXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:23:48 -0400
Message-ID: <46285C6B.7080101@sgi.com>
Date: Fri, 20 Apr 2007 08:23:39 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       rja@sgi.com, holt@sgi.com
Subject: Re: [PATCH] ia64 sn xpc: Convert to use kthread API.
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>	<1176969574439-git-send-email-ebiederm@xmission.com> <20070419165103.5b671b28.akpm@linux-foundation.org>
In-Reply-To: <20070419165103.5b671b28.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Another driver which should be fully converted to the kthread API:
> kthread_stop() and kthread_should_stop().
> 
> And according to my logs, this driver was added to the tree more than
> a year _after_ the kthread interface was made available.
> 
> This isn't good.

Andrew,

Per my previous response, I'd prefer to have either Russ or Robin ack
the patch doesn't break before it's pushed to Linus.

I don't know much about the xpmem and I am not comfortable testing it.

Cheers,
Jes
