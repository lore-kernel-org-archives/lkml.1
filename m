Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbXIAWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbXIAWQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbXIAWQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:16:07 -0400
Received: from mail.suse.de ([195.135.220.2]:45544 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbXIAWQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:16:05 -0400
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com> <200708301432.11516.rob@landley.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Sep 2007 00:16:03 +0200
In-Reply-To: <200708301432.11516.rob@landley.net>
Message-ID: <p73lkbqvxp8.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:
> 
> A lot of embedded people like to configure /proc out of the kernel for space 
> reasons.  This would make that noticeably more painful.

I had a patch for a sysctl_name(2) for this a long time ago.
If it was a serious issue that could be reintroduced.

BTW sysctl(2) only needs to be quiet for a single sysctl used
by glibc.

-Andi
