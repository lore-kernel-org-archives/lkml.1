Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbXAaBY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbXAaBY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbXAaBY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:24:27 -0500
Received: from web36715.mail.mud.yahoo.com ([209.191.85.49]:43507 "HELO
	web36715.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932138AbXAaBY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:24:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=AGIH4Aq0TWOmKUmFyKakJBoaOMqDW3OZT15UEEhyazjXUvlldaCFnGyIqdQ6qxhJaCbfGq0kxrC4e2/fzAzxFCvivfJcUc2Lhif0gxPBq+P0DrD1ne0tdFiq7vszTs06uQVu7EZO5J6esRiNuj/03cLPdSNRy9ZrfMDizGX2Tg0=;
X-YMail-OSG: tS4hDX4VM1nfMewL8xmaQsjVqffLb8KdsrDanZvNQHtX.nyVMzOQaITkSeYpLUX3a6cBTXy56MMcbCsp6PFvRlPea45k8cS5R0Xs9c39F.OS2AgkfiKsTpct0A__WIVVAUMRMtvAo3KG6NsxzccvrqY6IDX.kz9p
Date: Tue, 30 Jan 2007 17:24:25 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: MMC: tifm_7xx1 driver detects card but does not make it mountable
To: bloch@verdurin.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070130233021.GN14953@bloch.config>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <27134.31247.qm@web36715.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Memorystick support is not yet implemented (work in progress).

--- bloch@verdurin.com wrote:

> Running recent kernels the insertion of a MemoryStick into the card
> reader of a Sony Vaio VGNSZ3XWP is detected but the card does not seem
> to be probed for partitions and hence is not made available to
> userspace.
> 
> Here is the message upon card insertion:
> 
> tifm_7xx1: ms card detected in socket 0
> 
> lspci:
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
> 945GT Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile
> 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML
> Express Integrated Graphics Controller (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
> Definition Audio Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 2 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 3 (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 4 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
> Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
> Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
> Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
> Serial ATA Storage Controller IDE (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
> (rev 02)
> 06:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> Network Connection (rev 02)
> 07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8036 PCI-E
> Fast Ethernet Controller (rev 15)
> 09:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> 09:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
> IEEE 1394 Host Controller
> 09:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
> Card Reader (SD/MMC/MS/MS PRO/xD)
> 
> lsusb:
> 
> Bus 004 Device 001: ID 0000:0000  
> Bus 004 Device 002: ID 044e:300c Alps Electric Co., Ltd 
> Bus 003 Device 002: ID 0483:2016 SGS Thomson Microelectronics
> Fingerprint Reader
> Bus 003 Device 001: ID 0000:0000  
> Bus 001 Device 001: ID 0000:0000  
> Bus 005 Device 001: ID 0000:0000  
> Bus 005 Device 004: ID 05ca:1830 Ricoh Co., Ltd 
> Bus 005 Device 002: ID 054c:0281 Sony Corp. 
> Bus 002 Device 001: ID 0000:0000  
> 
> 
> Adam
> 



 
____________________________________________________________________________________
TV dinner still cooling? 
Check out "Tonight's Picks" on Yahoo! TV.
http://tv.yahoo.com/
