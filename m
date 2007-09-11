Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXIKM1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXIKM1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932370AbXIKM1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:27:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35490 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbXIKM1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:27:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: build #301 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/net/wireless/libertas/
Date: Tue, 11 Sep 2007 14:38:46 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200709111335.12216.toralf.foerster@gmx.de>
In-Reply-To: <200709111335.12216.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709111438.47212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 September 2007 13:35, Toralf Förster wrote:
> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   LD      arch/i386/boot/compressed/vmlinux
>   OBJCOPY arch/i386/boot/vmlinux.bin
>   HOSTCC  arch/i386/boot/tools/build
>   BUILD   arch/i386/boot/bzImage
> Root device is (3, 8)
> Setup is 10456 bytes (padded to 10752 bytes).
> System is 2138 kB
> Kernel: arch/i386/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 353 modules
> ERROR: "libertas_remove_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_add_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_send_tx_feedback" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_prepare_and_send_command" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_remove_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_add_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_process_rxed_packet" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_interrupt" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> ERROR: "libertas_activate_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> The build was made with an old .config from kernel 2.6.22-rc6
> (where the build also failed) :
> $> make mrproper && cp <oldconfig> .config && make oldconfig && make

Well, it looks like there are some symbols undefined in the libertas USB
driver ...

This code is not known to me, so I can't help you here.

Greetings,
Rafael
