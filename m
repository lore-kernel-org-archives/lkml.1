Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZCHWGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZCHWGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZCHWG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:06:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbZCHWG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:06:27 -0400
Date: Sun, 8 Mar 2009 23:06:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090308220609.GA23447@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org> <20090302120859.GB29015@elte.hu> <49B23907.8030103@goop.org> <20090308110150.GA19151@elte.hu> <49B43F1D.2000400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B43F1D.2000400@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> > 
> > Associativity effects do depend on the kernel image layout 
> > and on the precise allocations of kernel data structure 
> > allocations we do during bootup - and they dont really 
> > change after that.
> > 
> 
> By the way, there is a really easy way (if a bit time 
> consuming) to get the actual variability here -- you have to 
> reboot between runs, even for the same kernel.  It makes the 
> data collection take a long time, but at least it can be 
> scripted.

Since it's the same kernel image i think the only truly reliable 
method would be to reboot between _different_ kernel images: 
same instructions but randomly re-align variables both in terms 
of absolute address and in terms of relative position to each 
other. Plus randomize bootmem allocs and never-gets-freed-really 
boot-time allocations.

Really hard to do i think ...

	Ingo
