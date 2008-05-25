Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYEYSbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYEYSbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYEYSa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:30:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41432 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYEYSa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:30:57 -0400
Date: Sun, 25 May 2008 20:31:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jike Song <albcamus@gmail.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [GIT PULL] kbuild fixes
Message-ID: <20080525183136.GA12806@uranus.ravnborg.org>
References: <20080525071228.GA32120@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525071228.GA32120@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 09:12:28AM +0200, Sam Ravnborg wrote:
> Hi Linus.
> 
> Please pull from:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
> 
> This fixes the 'make oldconfig' regression you reported.
> And in addition a small .gitignore and ver_linux update.
> 
> 	Sam
> 
> The pull includes the following patches:
> 
> Gabriel C (1):
>       scripts/ver_linux use 'gcc -dumpversion'
> 
> Jike Song (1):
>       .gitignore: match ncscope.out
> 
> Sam Ravnborg (1):
>       Kconfig: add KBUILD_DEFCONFIG to DEFCONFIG_LIST

And this commit caused my make to enter an
infinite looke calling scripts/kconfig/conf -s arch/x86/Kconfig
Reproduceable by:
make defconfig
make

[on my 32 bit x86]

May try to dig into this later tonight.

For now I have dropped all commits from kbuild-fixes.git so
the bad commit does not end up in -linus, -next or -mm.

	Sam
