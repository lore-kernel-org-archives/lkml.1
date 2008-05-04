Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYEDVfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYEDVfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYEDVfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:35:40 -0400
Received: from tur.go2.pl ([193.17.41.50]:35372 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbYEDVfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:35:40 -0400
From: tockar <tockar@o2.pl>
To: linux-kernel@vger.kernel.org
Subject: Problem with sensors on linux 2.6.25
Date: Sun, 4 May 2008 23:34:03 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805042334.03574.tockar@o2.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I've strange problem with Linux 2.6.25 and later (I've compiled 2.6.26-rc1 and 
I have same problem). In 'sensors' command result, I get ALARMs. 
Here's 'sensors' result on Linux 2.6.24:

it87-isa-0290
Adapter: ISA adapter
VCore 1:     +1,71 V  (min =  +3,97 V, max =  +1,95 V)
VCore 2:     +3,09 V  (min =  +3,82 V, max =  +1,01 V)
+3.3V:       +3,07 V  (min =  +3,82 V, max =  +3,06 V)
+5V:         +5,59 V  (min =  +4,27 V, max =  +5,11 V)
+12V:       +13,31 V  (min = +15,62 V, max =  +7,74 V)
-12V:        -2,69 V  (min =  -0,61 V, max =  +3,44 V)
-5V:         -9,14 V  (min =  +3,82 V, max =  -2,62 V)
Stdby:       +0,00 V  (min =  +6,37 V, max =  +5,03 V)
VBat:        +3,25 V
fan1:       5152 RPM  (min =    0 RPM, div = 2)
fan2:          0 RPM  (min =    0 RPM, div = 2)
M/B Temp:    +34,0°C  (low  =  -7,0°C, high = -11,0°C)  sensor = transistor
CPU Temp:    +33,0°C  (low  = -66,0°C, high = +127,0°C)  sensor = transistor
Temp3:       +31,0°C  (low  = -33,0°C, high = -101,0°C)  sensor = transistor

Two minutes later, on Linux 2.6.25:

it87-isa-0290
Adapter: ISA adapter
VCore 1:     +1,71 V  (min =  +3,97 V, max =  +1,95 V)   ALARM
VCore 2:     +3,09 V  (min =  +3,82 V, max =  +1,01 V)   ALARM
+3.3V:       +3,07 V  (min =  +3,82 V, max =  +3,06 V)   ALARM
+5V:         +5,59 V  (min =  +4,27 V, max =  +5,11 V)   ALARM
+12V:       +13,31 V  (min = +15,62 V, max =  +7,74 V)   ALARM
-12V:        -2,69 V  (min =  -0,61 V, max =  +3,44 V)   ALARM
-5V:         -9,14 V  (min =  +3,82 V, max =  -2,62 V)   ALARM
Stdby:       +0,00 V  (min =  +6,37 V, max =  +5,03 V)   ALARM
VBat:        +3,25 V
fan1:       5152 RPM  (min =    0 RPM, div = 2)
fan2:          0 RPM  (min =    0 RPM, div = 2)
M/B Temp:    +35,0°C  (low  =  -7,0°C, high = -11,0°C)  sensor = transistor
CPU Temp:    +33,0°C  (low  = -66,0°C, high = +127,0°C)  sensor = transistor
Temp3:       +32,0°C  (low  = -33,0°C, high = -101,0°C)  sensor = transistor

Results are almost identical, but I get those ALARMs. I've Pentium4 1,4Ghz 
processor, module for my mainboard is BLK_DEV_VIA82CXXX. Is that a bug? Can I 
safely use Linux 2.6.25 or later?
