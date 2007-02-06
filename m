Return-Path: <linux-kernel-owner+w=401wt.eu-S965395AbXBFUBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395AbXBFUBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXBFUBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:01:08 -0500
Received: from smtp19.orange.fr ([80.12.242.1]:2697 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965395AbXBFUBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:01:06 -0500
X-ME-UUID: 20070206200101960.EA6151C003EB@mwinf1929.orange.fr
Message-ID: <45C8DE76.5000109@wanadoo.fr>
Date: Tue, 06 Feb 2007 21:00:54 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: error 2 after a compile
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !
I'm trying to compile a kernel from 2.6.17-10 to 2.6.19 with suspend2.
After this command :
make-kpkg --append-to-version=swsusp2.070206 kernel_image --initrd 
kernel_headers --revision=2.6.1

I obtain :
  Building modules, stage 2.
   MODPOST 1479 modules
WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
WARNING: "try_to_freeze" [drivers/usb/atm/ueagle-atm.ko] undefined!
make[2]: *** [__modpost] Erreur 1
make[1]: *** [modules] Erreur 2
make[1]: quittant le répertoire « /home/hulin/src/linux-2.6.19 »
make: *** [debian/stamp-build-kernel] Erreur 2

I don't understand the error ?

Thanks for help,
Thibaud.

