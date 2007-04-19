Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbXDSQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbXDSQWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXDSQWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:22:18 -0400
Received: from pat.uio.no ([129.240.10.15]:54144 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXDSQWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:22:18 -0400
Subject: Re: [PATCH] nfs lockd reclaimer: Convert to kthread API
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
In-Reply-To: <11769696321319-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769696321319-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 12:21:50 -0400
Message-Id: <1176999710.6663.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.214)
X-UiO-Scanned: 35F0990BE3E60C38DB4EBD28383CC7C721B099A1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 453 total 1195275 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 01:58 -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Start the reclaimer thread using kthread_run instead
> of a combination of kernel_thread and daemonize.
> The small amount of signal handling code is also removed
> as it makes no sense and is a maintenance problem to handle
> signals in kernel threads.

Vetoed. Removing stuff just because it doesn't make sense to you is not
acceptable.

Signal handling in reclaimer threads is there in order to allow
administrators to deal with the case where the server never comes up
again.

Trond

