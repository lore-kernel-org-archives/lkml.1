Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXFMI5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXFMI5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbXFMI5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:57:23 -0400
Received: from barikada.upol.cz ([158.194.242.200]:41160 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXFMI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:57:22 -0400
X-Greylist: delayed 869 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 04:57:22 EDT
Date: Wed, 13 Jun 2007 10:55:14 +0200
To: Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Removing of dummy asm-offset files (Re: [patch 02/03] kbuild, asm-values: successor of asm-offsets)
Message-ID: <20070613085514.GI7266@flower.upol.cz>
References: <20070612233650.486224000@flower.upol.cz> <20070612234558.782193000@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612234558.782193000@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[]
> +# legacy asm-offsets support (FIXME: convert all archs and remove this)
> +old = $(shell test -e $(srctree)/arch/$(ARCH)/kernel/asm-offsets.c && echo yes)
> +ifeq ($(old),yes)
> +    asm-values	=asm-offsets
> +else
> +    asm-values	=asm-values

One more test here, and files like
|-*-
olecom@flower:/mnt/work/pc/kernel.org/linux-2.6.22-rc4-mm2$ <
arch/sparc64/kernel/asm-offsets.c dd
/* Dummy asm-offsets.c file. Required by kbuild and ready to be used - hint! */
|-*-
can be removed.
____
