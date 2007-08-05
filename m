Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXHEBqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXHEBqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 21:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765401AbXHEBpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 21:45:51 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:42844 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765083AbXHEBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 21:45:50 -0400
Date: Sat, 4 Aug 2007 21:45:28 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Meelis Roos <mroos@linux.ee>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: spurious NCQ completions from FUJITSU MHW2120BH
In-Reply-To: <Pine.SOC.4.64.0708032310420.16401@math.ut.ee>
Message-ID: <Pine.LNX.4.64.0708042135190.5127@lancer.cnet.absolutedigital.net>
References: <Pine.SOC.4.64.0708032310420.16401@math.ut.ee>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="118098437-137499810-1186278092=:5127"
Content-ID: <Pine.LNX.4.64.0708042141530.5127@lancer.cnet.absolutedigital.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--118098437-137499810-1186278092=:5127
Content-Type: TEXT/PLAIN; CHARSET=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0708042141531.5127@lancer.cnet.absolutedigital.net>

On Fri, 3 Aug 2007, Meelis Roos wrote:

> Todays git gave me some EH errors during fsck (30 times mounted and time=
=20
> to check), then recovered and works fine. Seems to be spurious NCQ=20
> completion. The disk is
>=20
> Device Model:     FUJITSU MHW2120BH
> Firmware Version: 00000012
> User Capacity:    120=A0034=A0123=A0776 bytes

As a data point: I've got the same drive w/ same revision in my laptop and=
=20
haven't had any NCQ errors pop up. Currently running 2.6.23-rc2.

 ata1.00: ATA-8: FUJITSU MHW2120BH, 00000012, max UDMA/100
 ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
 ata1.00: configured for UDMA/100

Might be dependent on the controller and/or the driver. Got a nVidia MCP51=
=20
using sata_nv here.

--=20
Cal Peake
--118098437-137499810-1186278092=:5127--
