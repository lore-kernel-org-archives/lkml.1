Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbZATAfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbZATAfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbZATAfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:35:19 -0500
Received: from ns1.suse.de ([195.135.220.2]:43567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbZATAfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:35:18 -0500
Date: Tue, 20 Jan 2009 01:35:16 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bryan Donlan <bdonlan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #12498] OOPS and panic on 2.6.29-rc1 on xen-x86
Message-ID: <20090120003516.GC16304@wotan.suse.de>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.fgG.b9QdJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2QN7KFic7LG.A.fgG.b9QdJB@chimera>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:32:16PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12498
> Subject		: OOPS and panic on 2.6.29-rc1 on xen-x86
> Submitter	: Bryan Donlan <bdonlan@gmail.com>
> Date		: 2009-01-12 17:26 (8 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e97a630eb0f5b8b380fd67504de6cedebb489003
> References	: http://marc.info/?l=linux-kernel&m=123178178029065&w=4
> Handled-By	: Nick Piggin <npiggin@suse.de>
> 

This one was fixed by backing out the patch to make vmalloc purge
spinlock into a mutex.
