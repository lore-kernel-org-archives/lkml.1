Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXA3UDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXA3UDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXA3UDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:03:09 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:36406 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXA3UDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:03:07 -0500
Date: Tue, 30 Jan 2007 21:02:20 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Luca Tettamanti <kronos.it@gmail.com>
cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
In-Reply-To: <20070130195319.GA10994@dreamland.darkstar.lan>
Message-ID: <Pine.LNX.4.61.0701302100370.13737@yvahk01.tjqt.qr>
References: <20070130195319.GA10994@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2007 20:53, Luca Tettamanti wrote:
>Hi,
>pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that

Did it work previously?

>is written to the device is lost after umount.
>I rarely use pktcdvd but at some point it used to work on my system.
>
>This is what I'm doing:
>
>root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
>scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5

In case you are using ide-scsi: try without.


Jan
-- 
