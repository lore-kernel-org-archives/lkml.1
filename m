Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYGPTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYGPTWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYGPTWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:22:04 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:60043 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYGPTWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:22:03 -0400
Date: Wed, 16 Jul 2008 15:22:02 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-stable@linux-mips.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: MIPS toolchain
Message-ID: <20080716192202.GA27827@phobos.i.cabal.ca>
References: <487DA40C.6010405@movial.fi> <20080716104533.GA7198@linux-mips.org> <487DD559.3020802@movial.fi> <20080716120224.GA6061@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716120224.GA6061@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 01:02:24PM +0100, Ralf Baechle wrote:
> +include $(srctree)/arch/$(SRCARCH)/Makefile
> +
>  ifneq (CONFIG_FRAME_WARN,0)
>  KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
>  endif
> @@ -517,8 +519,6 @@ endif
>  # Arch Makefiles may override this setting
>  KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
>  
> -include $(srctree)/arch/$(SRCARCH)/Makefile
> -
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls

Cool, this explains something I saw with a crossbuild as well, but never
had time to debug.

r, Kyle
