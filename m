Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbYDNApw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbYDNApw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYDNApo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:45:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYDNApn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:45:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexia Death <alexiadeath@gmail.com>
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
Date: Mon, 14 Apr 2008 02:45:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200804132326.07713.alexiadeath@gmail.com>
In-Reply-To: <200804132326.07713.alexiadeath@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804140245.33171.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/+o8rFmZTLz3PKY5fwtJJ5iKcDiOin7i+OK6r
 J+lewFxCZ4GfQiKVb1eaR2bPLs7nTyRgwlYn/fJIscaGSPnXLK
 wWRNe3X1wHl0w0UNcuWMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008, Alexia Death wrote:
> [1193601.236730] sd 2:0:0:2: [sdd] Write Protect is off
> [1193601.236745] sd 2:0:0:2: [sdd] Mode Sense: 03 00 00 00
> [1193601.236752] sd 2:0:0:2: [sdd] Assuming drive cache: write through
> [1193601.236768]  sdd: sdd1
> [1193601.248543]  sdd: p1 exceeds device capacity
> [1193601.248740] sd 2:0:0:2: [sdd] Attached SCSI removable disk
> [1193601.248853] sd 2:0:0:2: Attached scsi generic sg4 type 0
> [1193601.258517] sd 2:0:0:3: [sde] Attached SCSI removable disk
> [1193601.258639] sd 2:0:0:3: Attached scsi generic sg5 type 0

You are apparently using a SCSI device, so I assume it is a USB
based card reader, not a directly attached SD/MMC reader.

My guess is that the problem is the way that the card is presented
to the USB mass storage driver by the reader. Generally, there is
no problem with 2GB SD cards, so it would be good if you can try
a different card reader with your cards.

Also, please supply the "lsusb -v" output for the card reader.

	Arnd <><
