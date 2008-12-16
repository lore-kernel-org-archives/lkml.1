Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYLPKdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYLPKdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYLPKdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:33:46 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:57382 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbYLPKdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=XJXFaclOKGOCfZbZOd6emR1hLLT8JJ7CjdHxwyzl8Q+fnUMP1wWwwHsyZMIhEeZErN
         nHBdcdVsoXK2eVkMeDhfT58ZxAHGejW7XZ/Sy+pb2YYHWUbLPInmmyzR6l1qDkAXSxVf
         cFsudH3lJNLJ32Df4TJwLi9/CB04c/1sCb6is=
Message-ID: <bb6c380c0812160233i26da273du643cc32aaa9eb782@mail.gmail.com>
Date: Tue, 16 Dec 2008 11:33:42 +0100
From: liga <alessioligabue@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernels > 2.6.19.7 freezes over epia mii-6000 (VT8633) with sata VT6421 pci controller
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a problem with my VT6421 sata controller, after some hours it
freeze bad with all the kernel > 2.6.19.7.
I have tried ~ 10 kernel with the same result (2 compiled by Debian),
it seem to be a bug in sata_via module (but I'm not sure) because I
have tried with a old ide disk the kernels and they runs correctly.
No messages on the kernel serial console.
I hope that you can help me.
Thank you.
Alessio

My lspci:
00:00.0 Host bridge: VIA Technologies, Inc. VT8623 [Apollo CLE266]
00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP]
00:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 82)
00:0a.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 82)
00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II
IEEE 1394 OHCI Link Layer Controller (rev 80)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80)
00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 74)
00:14.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID
Controller (rev 50)
01:00.0 VGA compatible controller: VIA Technologies, Inc. VT8623
[Apollo CLE266] integrated CastleRock graphics (rev 03)

-- 
Registered Linux user number 404688
