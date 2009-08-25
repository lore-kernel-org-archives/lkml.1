Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZHYX5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZHYX5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZHYX5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:57:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:39059 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753875AbZHYX5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:57:46 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18AGrFK1hQAul+pPmEXjuFsZxVZvYpc4/mdGOLz4+
	ZCuC2JnFC7cRy4
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14031] dvb_usb_af9015: Oops on hotplugging
Date: Wed, 26 Aug 2009 01:57:45 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc7-sidux-amd64; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.RvG.1sGlKB@chimera>
In-Reply-To: <_yaHeGjHEzG.A.RvG.1sGlKB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908260157.48560.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 26 August 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14031
> Subject		: dvb_usb_af9015: Oops on hotplugging
> Submitter	: Stefan Lippers-Hollmann <s.L-H@gmx.de>
> Date		: 2009-08-05 20:32 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=124949716608828&w=4

This issue does not exist in 2.6.31-rc7(-git2) anymore. 

Unfortunately I've been away from my system and with limited testing 
abilities recently, so I can't pinpoint the actual patch that fixed this 
(it was not in the first DVB pull request following that report, but maybe 
in the second or third), but it does work very well again. Thank you.

Regards
	Stefan Lippers-Hollmann

usb 1-6: new high speed USB device using ehci_hcd and address 4
usb 1-6: New USB device found, idVendor=0ccd, idProduct=0069
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6: Product: Cinergy T USB XE Ver.2
usb 1-6: Manufacturer: TerraTec
usb 1-6: SerialNumber: 10012007
usb 1-6: configuration #1 chosen from 1 choice
dvb-usb: found a 'TerraTec Cinergy T USB XE' in cold state, will try to load a firmware
usb 1-6: firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'TerraTec Cinergy T USB XE' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TerraTec Cinergy T USB XE)
af9013: firmware version:4.95.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
mc44s803: successfully identified (ID = 14)
dvb-usb: TerraTec Cinergy T USB XE successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_af9015
