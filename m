Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXDUTGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXDUTGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXDUTGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:06:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35618 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXDUTGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:06:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] nfs lockd reclaimer: Convert to kthread API
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769696321319-git-send-email-ebiederm@xmission.com>
	<1176999710.6663.12.camel@heimdal.trondhjem.org>
	<m1slawkw76.fsf@ebiederm.dsl.xmission.com>
	<1177017564.6628.5.camel@heimdal.trondhjem.org>
	<1177017902.12599.173.camel@localhost.localdomain>
Date: Sat, 21 Apr 2007 13:04:16 -0600
In-Reply-To: <1177017902.12599.173.camel@localhost.localdomain> (Dave Hansen's
	message of "Thu, 19 Apr 2007 14:25:02 -0700")
Message-ID: <m1vefpim6n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <hansendc@us.ibm.com> writes:

> On Thu, 2007-04-19 at 17:19 -0400, Trond Myklebust wrote:
>> > With pid namespaces all kernel threads will disappear so how do
>> > we cope with the problem when the sysadmin can not see the kernel
>> > threads?
>
> Do they actually always disappear, or do we keep them in the
> init_pid_namespace?

In the init pid namespace but not in any of it's children.

Eric
