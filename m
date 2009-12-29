Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZL2VGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZL2VGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZL2VGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:06:07 -0500
Received: from vps2.mechanicalrealm.com ([66.216.20.21]:53036 "EHLO
	zinan.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZL2VGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:06:05 -0500
From: "Luke-Jr" <luke@dashjr.org>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
Date: Tue, 29 Dec 2009 15:05:46 -0600
User-Agent: KMail/1.12.3 (Linux/2.6.32-gentoo; KDE/4.3.3; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe \(Nokia-D\/Helsinki\)" <felipe.balbi@nokia.com>
References: <200912290152.16357.luke@dashjr.org> <200912290246.57663.luke@dashjr.org> <873a2uxip9.fsf@purkki.valot.fi>
In-Reply-To: <873a2uxip9.fsf@purkki.valot.fi>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912291505.51230.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009 02:55:46 am Kalle Valo wrote:
> Having lots of small files is difficult IMHO.

The last-working N8x0 support (Linux-OMAP 2.6.30-rc8) required 1706 lines of 
platform data and initialization, split up into 6 files:
	590	N800 + i2c + FM + keyboard + light sensor + LED + LCD + temp + SPI + WiFi
		 + touchscreen + OneNAND
	47	N810
	175	USB
	362	MMC
	156	DSP
	376	camera

The largest OMAP2 single-board file is merely 689 lines (3430sdp).
N900/RX-51, totalling 863 lines itself, is split over 2 files.

I think 4 or 5 files with ~350 lines is more manageable than a single 1700-
line board file, especially when considering that parts depend on multiple 
configuration options (LCD, which turns out to be a 128-line file, depends on 
3 config options: N8x0, Blizzard, and MIPID).

Thoughts?

Luke
