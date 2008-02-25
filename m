Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYBYUpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYBYUpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYBYUou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:44:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33998 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131AbYBYUot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:44:49 -0500
Date: Mon, 25 Feb 2008 21:44:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compile problem in current x86.git
Message-ID: <20080225204438.GA1213@elte.hu>
References: <47C315CC.5020001@goop.org> <19f34abd0802251237q2aa5db03s522c77340cdc96a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0802251237q2aa5db03s522c77340cdc96a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >  asm-x86/kmemcheck.h does seem to be completely missing.  Looks like 
> >  8db0acefb3025795abe3f37669354677a03de680 "x86: add hooks for 
> >  kmemcheck" should have added the file.
> 
> Hm. This is x86#testing, no? I don't think there's any kmemcheck code 
> whatsoever in other branches.
> 
> The file should be added with this commit:
> 
> kmemcheck: add the kmemcheck core 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commit;h=c83d05d69382945c92a2e7a2b168c1cc2aa77c29

yes, x86.git looks fine here too:

 ~/linux.trees.git> git-checkout -b tmp x86/testing
 Branch tmp set up to track remote branch refs/remotes/x86/testing.
 Switched to a new branch "tmp"
 ~/linux.trees.git> cd include/asm-x86/
 ~/linux.trees.git/include/asm-x86> ls -l kmemcheck.h
 -rw-rw-r-- 1 mingo mingo 55 2008-02-25 21:41 kmemcheck.h
 ~/linux.trees.git/include/asm-x86> cd ..
 ~/linux.trees.git/include> cd ..
 ~/linux.trees.git> ls -ldt include/asm-x86/kmemcheck.h
 -rw-rw-r-- 1 mingo mingo 55 2008-02-25 21:41 include/asm-x86/kmemcheck.h
 ~/linux.trees.git> git-log | head -1
 commit c9d2f5489cec70f814bf64033290e5f05b4d7f33

	Ingo
