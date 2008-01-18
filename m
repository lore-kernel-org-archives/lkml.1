Return-Path: <linux-kernel-owner+w=401wt.eu-S1762965AbYARUwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762965AbYARUwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762317AbYARUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:52:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53435 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765967AbYARUwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:52:03 -0500
Date: Fri, 18 Jan 2008 21:51:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes for v2.6.24
Message-ID: <20080118205152.GF3079@elte.hu>
References: <20080118154809.GA18248@elte.hu> <20080118191249.GA20384@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118191249.GA20384@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > @@ -1088,7 +1088,7 @@ CLEAN_FILES +=	vmlinux System.map \
> >                  .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
> >  
> >  # Directories & files removed with 'make mrproper'
> > -MRPROPER_DIRS  += include/config include2 usr/include
> > +MRPROPER_DIRS  += include/config include2 usr/include arch/i386 arch/x86_64
> sigh - arch specific stuff in the top-level Makefile.
> This really belongs in arch/x86/Makefile

is this a NACK? Can clean this up in v2.6.25, but this seemed the only 
simple solution for v2.6.24.

	Ingo
