Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbXFZHCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbXFZHCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 03:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFZHCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 03:02:38 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52512 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751426AbXFZHCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 03:02:38 -0400
Date: Tue, 26 Jun 2007 09:02:22 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: bennett78@lpbroadband.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kernel@avr32linux.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AVR32 fixes
Message-ID: <20070626090222.2f4abe6e@dhcp-255-175.norway.atmel.com>
In-Reply-To: <46802222.90104@lpbroadband.net>
References: <20070623164143.2bba7104@dhcp-255-175.norway.atmel.com>
	<46802222.90104@lpbroadband.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 14:14:26 -0600
Frank Bennett <bennett78@lpbroadband.net> wrote:

> makes fine, but requires :

Hmm...what do you mean?

> export ARCH=avr32
> export CROSS_COMPILE=avr32-linux-

Standard cross-compile stuff.

> make defconfig
> make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   MODPOST vmlinux
>   UIMAGE arch/avr32/boot/images/uImage
> "mkimage" command not found - U-Boot images will not be built

Seems like you don't have mkimage installed. You can find it under
"tools" in the u-boot sources.

>   Image arch/avr32/boot/images/uImage is ready
> make[1]: `arch/avr32/boot/images/vmlinux.elf' is up to date.
>   Building modules, stage 2.
>   MODPOST 20 modules

I'm sorry, but I don't understand what's wrong here...

Haavard
