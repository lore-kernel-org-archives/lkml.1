Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYCWEpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYCWEpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 00:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYCWEpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 00:45:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:30331 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYCWEpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 00:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SIAaHDxUHBtXprrBm+IHuMJI8Bm+NDen8ORmaHrutBPaGI5VQ+y5bzxvLN4Jh1hdWLcEABMl+/1BgZDd1/CtxyynMtp38Gnf9CiRxmxtSU+pEUjL6R6g2ZSuj+wczLgFQE216rN5K1depciwgLMnboAfwKndluy0m17LxPUET0M=
Message-ID: <5b1d25eb0803222145t2fd23a1h6d825c494768b418@mail.gmail.com>
Date: Sat, 22 Mar 2008 21:45:03 -0700
From: "Sreen Tallam" <tallam.sreen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel hangs on 2.6.18 (PPC405GP with custom board)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am trying to boot a Montavista edition 2.6.18 on a PPC405GP for a
custom board- very close to the Walnut board.
I seem to be hanging at the early stage, and nothing is printed on to
the console. Has anyone dealt with this issue?

I am following the device tree approach - arch/powerpc

=> tftp 0x800000 /tftpboot/kernel_5_2
ENET Speed is 100 Mbps - FULL duplex connection
TFTP from server 172.22.101.2; our IP address is 172.22.101.177
Filename '/tftpboot/kernel_5_2'.
Load address: 0x800000
Loading: #################################################################
         #################################################################
         #################################################################
         ###########################################
done
Bytes transferred = 1216832 (129140 hex)
=> bootm 0x800000
## Booting image at 00800000 ...
   Image Name:   Linux-2.6.18_pro500
   Created:      2008-03-23   4:22:08 UTC
   Image Type:   PowerPC Linux Kernel Image (gzip compressed)
   Data Size:    1216768 Bytes =  1.2 MB
   Load Address: 00400000
   Entry Point:  0040061c
   Verifying Checksum ... OK
   Uncompressing Kernel Image ... OK
## Current stack ends at 0x03FAD548 => set upper limit to 0x00800000
## cmdline at 0x007FFC00 ... 0x007FFD04
gd address  = 0x03FADF18
bd address  = 0x03FADF48
memstart    = 0x00000000
memsize     = 0x04000000
flashstart  = 0xFF000000
flashsize   = 0x01000000
flashoffset = 0x00000000
sramstart   = 0x00000000
sramsize    = 0x00000000
bootflags   = 0x0000A000
procfreq    =    100 MHz
plb_busfreq =    100 MHz
pci_busfreq =     50 MHz
ethaddr     = 00:A0:98:04:92:88
IP addr     = 172.22.101.177
baudrate    =   9600 bps
No initrd
## Transferring control to Linux (at address 0040061c) ...

One thing, my console is on UART1 and I am compiling this information
in the .config for the kernel
CONFIG_CMDLINE="console=ttyS1,9600 root=/dev/mtdblock7 ro init=/sbin/try_init"

Any help is appreciated.

Thanks,
Sreen
