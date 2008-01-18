Return-Path: <linux-kernel-owner+w=401wt.eu-S1765637AbYARTMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765637AbYARTMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762808AbYARTMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:12:43 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42590 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761446AbYARTMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:12:43 -0500
Date: Fri, 18 Jan 2008 20:12:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes for v2.6.24
Message-ID: <20080118191249.GA20384@uranus.ravnborg.org>
References: <20080118154809.GA18248@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118154809.GA18248@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 04:48:09PM +0100, Ingo Molnar wrote:
> 
> Linus, please pull the latest x86 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> two fixes: a "make mrproper" bug and a new cpuid for oprofile, both 
> build/boot tested.
> 
> 	Ingo
> 
> ------------------>
> Arjan van de Ven (1):
>       x86: add support for the latest Intel processors to Oprofile
> 
> Michael Opdenacker (1):
>       x86: fix make mrproper
> 
>  Makefile                    |    2 +-
>  arch/x86/oprofile/nmi_int.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 713f685..a7aa374 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1088,7 +1088,7 @@ CLEAN_FILES +=	vmlinux System.map \
>                  .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
>  
>  # Directories & files removed with 'make mrproper'
> -MRPROPER_DIRS  += include/config include2 usr/include
> +MRPROPER_DIRS  += include/config include2 usr/include arch/i386 arch/x86_64
sigh - arch specific stuff in the top-level Makefile.
This really belongs in arch/x86/Makefile

	Sam
