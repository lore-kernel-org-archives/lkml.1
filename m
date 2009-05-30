Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbZE3Nnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbZE3Nnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbZE3Nnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:43:47 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37088 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746AbZE3Nnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:43:46 -0400
Date: Sat, 30 May 2009 15:46:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Generate per command manpages (and pdf/html, etc.)
Message-ID: <20090530134601.GA12088@uranus.ravnborg.org>
References: <tip-c1c2365acf8c044f749c0fe1ea236497e8d1718e@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c1c2365acf8c044f749c0fe1ea236497e8d1718e@git.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 01:00:33PM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  c1c2365acf8c044f749c0fe1ea236497e8d1718e
> Gitweb:     http://git.kernel.org/tip/c1c2365acf8c044f749c0fe1ea236497e8d1718e
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sat, 30 May 2009 12:38:51 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 30 May 2009 13:52:44 +0200
> 
> perf_counter tools: Generate per command manpages (and pdf/html, etc.)
> 
> Import Git's nice .txt => {man/html/pdf} generation machinery.
> 
> Fix various errors in the Documentation/perf*.txt description as well.
> 
> Also fix a bug in builtin-help: we'd map 'perf help top' to 'perftop'
> if only the 'perf' binary is in the default PATH - confusing the manpage
> logic. I dont fully understand why Git did it this way - but i suppose
> it's a migration artifact from their migration from standalone git-xyz
> commands to 'git xyz' commands. The perf tools were always using the
> modern form so it's not an issue there.

Can we please have this patch split in at least a infrastructire and
a content part.
This makes it easier to review - and also makes it
much more clear what is needed to be added when adding new
documentation following this format.

I would also suggest to copy Randy Dunlap on patches
touching generic parts like this in Documentation.

I will try to review this when the splitup has heppend.

[I may have been copied on stuff earlier but I has been
and is almost off-line atm].

Thanks,
	Sam
