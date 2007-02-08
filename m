Return-Path: <linux-kernel-owner+w=401wt.eu-S1161530AbXBHHzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161530AbXBHHzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161534AbXBHHzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:55:22 -0500
Received: from raven.upol.cz ([158.194.120.4]:51470 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161527AbXBHHzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:55:21 -0500
Date: Thu, 8 Feb 2007 09:04:08 +0100
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: search-a-little-harder-for-mkimage.patch
Message-ID: <20070208080408.GS22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org> <20070207203047.51a95ad0.akpm@linux-foundation.org> <20070208052439.GL22699@flower.upol.cz> <8bd0f97a0702072156q640d49b8of5f81a60b380ef81@mail.gmail.com> <20070208074213.GR22699@flower.upol.cz> <8bd0f97a0702072340w699ba70bre9d0828ae11c56b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0702072340w699ba70bre9d0828ae11c56b7@mail.gmail.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 02:40:28AM -0500, Mike Frysinger wrote:
[] 
> by this argument, why does mkuboot.sh exist at all then ?  let's
> simply delete mkuboot.sh and change all arch Makefile's like so:
> -    $(CONFIG_SHELL) $(MKIMAGE) ...
> +    -mkimage ...

Yes (with TOOLCHAIN prefix).

> i of course prefer the existing solution: call the mkuboot.sh script
> which checks for a few variations of the `mkimage` binary and if it
> does not exist, output a friendly message

so as `make' will, but better than patched "friendly message", which
doesn't reflect: neither change to toolchain prefix, nor possible
permission problems, or what ever it can be, preventing actual running
the command ;)

____
