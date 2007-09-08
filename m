Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbXIHSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbXIHSXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 14:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbXIHSXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 14:23:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40010 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbXIHSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 14:23:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46E2E87E.3060208@s5r6.in-berlin.de>
Date: Sat, 08 Sep 2007 20:22:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <90ZEn-1YU-3@gated-at.bofh.it> <918Rh-7Or-5@gated-at.bofh.it> <919aD-8ua-7@gated-at.bofh.it> <E1IU3Xv-0000d9-K0@be1.lrz>
In-Reply-To: <E1IU3Xv-0000d9-K0@be1.lrz>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> The real problem is hiding devices attached to some controlers between
> one kind of the controllers. This has been correct whern they were bus-
> specific, but since they are now shared by three busses, they should get
> their own menu called "(S)ATA/USB/SCSI attached devices" - or whatever a
> native speaker would suggest.

A side note:  SCSI is not a bus.  It is an architecture and a set of
implementation standards; including command set standards, transport
protocol standards and interconnect standards for a whole lot of
different applications, transports, and interconnects, and not all of
the latter are actual buses.  The oldest of SCSI interconnects, SCSI
Parallel Interconnect alias SPI, is often mistaken for all of SCSI even
though its role is diminishing.  There is much more:
http://www.t10.org/scsi-3.htm

You are right though that Linux' SCSI command set drivers and SCSI core
are used for non-SCSI transports too, and this is not very well
reflected by the configuration menu layout.  (But is there an ideal menu
layout?  I'm sure there isn't.)
-- 
Stefan Richter
-=====-=-=== =--= -=---
http://arcgraph.de/sr/
