Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYACRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYACRyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYACRyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:54:37 -0500
Received: from main.gmane.org ([80.91.229.2]:50417 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYACRyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:54:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300 card); 2.6.23.1(vanilla)
Date: Thu, 03 Jan 2008 18:54:21 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.01.03.17.54.20.172625@wizards.de>
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no> <4777E08C.4000603@shaw.ca> <4779870E.5070507@tlinx.org> <pan.2008.01.01.01.45.23.430875@wizards.de> <477BDA87.7030702@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-174.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got my Promise card and everything is up and running without problems,
using kernel 2.6.24-rc6 and the sata_promise driver out of the box:

00:0c.0 Mass storage controller: Promise Technology, Inc. PDC40775 (SATA 300 TX2plus) (rev 02)
        Subsystem: Promise Technology, Inc. PDC40775 (SATA 300 TX2plus)
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 17
        I/O ports at b400 [size=128]
        I/O ports at b800 [size=256]
        Memory at ef025000 (32-bit, non-prefetchable) [size=4K]
        Memory at ef000000 (32-bit, non-prefetchable) [size=128K]
        [virtual] Expansion ROM at 98020000 [disabled] [size=32K]
        Capabilities: [60] Power Management version 2
        Kernel driver in use: sata_promise

Drive is a Samsung HD321KJ 320 GB and hdparm says the drive does ~75
MB/s; with dd it does buffered writes at ~85 MB/s and reads ~295 MB/s. So
all in all I'd say it's not the card or the driver..

hth,
Holger


