Return-Path: <linux-kernel-owner+w=401wt.eu-S1752006AbXB0Sop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbXB0Sop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXB0Sop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:44:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:56231 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752006AbXB0Soo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:44:44 -0500
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 27 Feb 2007 19:44:42 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070227184442.21690@gmx.net>
MIME-Version: 1.0
Subject: bugs in 2.6.20 kernels
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19kuUZjQf5kdWNbyRUerGt+jgU9POYmCx7H5NLIb5
 AqJnO28xobECyTe6VO9aoEqF0= 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
one problem in this mail is already being discussed - excellent!
The rest is cced now to linux-kernel@vger.kernel.org just to take care for that it is not forgotten and to help to avoid that rubbish is not being pushed into mainline vanilla:

In the current 2.6.20 kernels I found three bugs:

A. kernel 2.6.20-mm1 plus kernel 2.6.20-git14
Bug 1: I cannot mount an ordinary floppy drive without hanging up the whole system (somewhere between git10 and git14).
Bug 2: If I boot my home LAN server with 2.6.20-mm1 this kernel freezes my Apache-2.2.3 services after a certain amount of time: The physical connection, controllable by ping, stays functionable, but I cannot address that apache server with my workstations any more (somewhere <= git14).

B. kernel 2.6.20-git14:
Bug 3: As I reported already nerolinux runs fine and excellent again, recognizes my burning devices and everything is fine so far.
BUT: One problem I reported in connection with those CD burning problems unfortunately still exists:
>From time to time my burning device is being reinitialized for whatever nonsense reason that I do not know. As if it would lose electricity or data connection for just a moment. The one consequence is that the KDE daemon arizes and tells me something about an audio CD in one of my drives:
/dev/hdc is a LG DVD drive
/dev/hdd is a TEAC CD W54 burning device.
But fact is both drives do not contain any Audio CD at all.
The other consequence is that dmesg tells me about endless drive seek errors. What a crucial bug! It does not happen immediately, but from time to time.
And I can promise that my hardware is fine! So this is no hardware bug at all. Timing problems? No idea!

I am working with an intel ICH 4 chipset on an ASUS P4 PE mainboard. My distro is Debian Etch snapshot from february 13, 2007.
This bug number 3 appeared first at the transition from 2.6.19 to 2.6.20-rc1 if I remember right (but not sure).
I did not have that problem with 2.6.19 and earlier kernels.
Would you please fix those errors please?

Best regards

Uwe

-- 
Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen! 
Ideal für Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
