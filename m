Return-Path: <linux-kernel-owner+w=401wt.eu-S933844AbXGaUdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbXGaUdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXGaU27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:28:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:25105 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762423AbXGaU24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:from:content-type:mime-version:content-transfer-encoding:message-id:user-agent;
        b=JuSPl3idaMmAbHEf/9jthqugtUNHrSB/m7zqL6GKtNOjQC7YqZR9+XrJNGDrwhqv3APRj+yq/rTYsgWmY83XDs1tqaqIow/ksPNdXn6g4mj15/J+nVkZrV0QRs9xXwv5QkfvHPvHND8WFiLz5fOfKvcznbibYozWq/oocIJ72sc=
Date: Tue, 31 Jul 2007 22:28:49 +0200
To: linux-kernel@vger.kernel.org
Subject: Reboot hang
From: kriko <kristjan.ugrin@gmail.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Message-ID: <op.twci6be2atcbto@linux.site>
User-Agent: Opera Mail/9.22 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a problem that I cannot solve by myself.

I experience hangs on reboot. Precisely hang occurs when I reboot from  
linux.
Bios show up its screen normally, but after it is done initializing  
devices it wont start booting from them (boot prio: dvd-rom, hd).
It just sits there on summary screen with blinking cursor (at this point  
normally a message appears up like booting from CD/DVD).
The only solution is to do a reboot (press ctrl+alt+del - it does respond  
to that) or to do a hard reset.
This doesn't happen if I shut down the system and then boot it up, or if I  
do a reset from win.

I already tried to boot with apm=off, but it doesn't help, my boot  
parameters are:
---
title openSUSE 10.2 - 2.6.22-custom
     root (hd0,0)
     kernel /boot/vmlinuz-2.6.22 root=/dev/sda1 vga=0x31A resume=/dev/sdb1  
splash=verbose showopts elevator=cfq
     initrd /boot/initrd-2.6.22
---

Bios is up-to-date. I tried reseting bios (and clearing cmos), but it  
doesn't solve the problem.

Here I included lsmod, dmesg and config:
http://files.myopera.com/kriko/files/sys.tar.gz

Computer specs:
Athlon 64 2800+ (S 754)
Gigabyte gak8nsp (nforce 3)
Geforce 7600GT
NEC DVD-RW@nv_pata
1x 80 GB WD@nv_sata, 1x 250 GB WD@nv_sata , IBM (20GB) @ nv_pata
SB Live! 5.1


-- 
kriko
