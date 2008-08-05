Return-Path: <linux-kernel-owner+w=401wt.eu-S1763045AbYHEVN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763045AbYHEVN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762524AbYHEVMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:12:53 -0400
Received: from web82105.mail.mud.yahoo.com ([209.191.84.218]:25659 "HELO
	web82105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761569AbYHEVMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:12:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=F+RucoSVexOqRgoHYN+tKmd/JqEf//AvWtxeTtQQp9MS7nh+AgIeoYpkg0USEpMyhTl8OBOMwSHFngKZM/NGRTZI2btK/55D/fTfJgFOh1uHhpuBiLWK5RXEw5kQ8RVmn6hZsB2p0n9F1pF7jPad6gh76NbjivL1fSvNGoLHqJ8=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 5 Aug 2008 14:12:51 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <511283.28596.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Since you have that git tree, could you try to see if the latest -git
> still has this problem?

  In a previous msg I mentioned that I had tried compiling the HEAD of
my git repository, but only after I had posted to LKML.  I was at work
when I wrote the prev msg, so I could not provide details except from
memory.

  OK, now I'm home:
======================================

$ git-show
commit 2b12a4c524812fb3f6ee590a02e65b95c8c32229
Merge: 4744b43... 7f30491...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Aug 1 14:59:11 2008 -0700

    Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6
    
    * 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6:
      [IA64] Move include/asm-ia64 to arch/ia64/include/asm

$ head Makefile
VERSION = 2
PATCHLEVEL = 6
SUBLEVEL = 27
EXTRAVERSION = -rc1
NAME = Rotary Wombat

# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
# More info can be located in ./README
# Comments in this file are targeted only to the developer, do not
======================================

  This kernel built fine, but froze at boot just like the 2.6.26 kernels,
unless using "hpet=disabled".
  Sorry that I forgot to do this before my orig. post.

Dave W.
