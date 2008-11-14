Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYKNAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYKNAIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYKNAHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:07:48 -0500
Received: from kroah.org ([198.145.64.141]:57768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754534AbYKNAHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:07:44 -0500
Date: Thu, 13 Nov 2008 16:07:25 -0800
From: Greg KH <greg@kroah.com>
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>,
       Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, netdev@vger.kernel.org
Subject: Re: [stable] build error with 2.6.27.6+reiser4+ehci-hub patch.
	ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
Message-ID: <20081114000725.GC19644@kroah.com>
References: <200811140045.20166.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811140045.20166.volker.armin.hemmann@tu-clausthal.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 12:45:19AM +0100, Volker Armin Hemmann wrote:
> Hi,
> with my old config from 2.6.27.5 (which has the same patches) I get this 
> error:
> make all modules_install install
> <snip>
>   OBJCOPY arch/x86/boot/setup.bin
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   HOSTCC  arch/x86/boot/tools/build
>   BUILD   arch/x86/boot/bzImage
> Root device is (9, 1)
> Setup is 11436 bytes (padded to 11776 bytes).
> System is 2180 kB
> CRC 54816509
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 136 modules
> ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2

Francois, this is due to your commit
38d501ca6eb1f05d238bef785e51ca71dbfe0115, in the release, which was a
backport of ccdffb9a88b2907b159538d7bfd6256621db4f84.

Care to look into this?

thanks,

greg k-h
