Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYDNIMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYDNIMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbYDNILu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:11:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.112.145]:11581 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbYDNILq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:11:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Mon, 14 Apr 2008 01:11:42 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Mon, 14 Apr 2008 16:11:34 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B26C12206@hkemmail01.nvidia.com>
In-Reply-To: <200804140841.32477.volker.armin.hemmann@tu-clausthal.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Thread-Index: Acid/anhfMuXYUF0RJmFqhd3NDEOOgAB8hzg
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <480013A3.1010502@garzik.org> <15F501D1A78BD343BE8F4D8DB854566B26C11B8C@hkemmail01.nvidia.com> <200804140841.32477.volker.armin.hemmann@tu-clausthal.de>
From: "Peer Chen" <pchen@nvidia.com>
To: "Volker Armin Hemmann" <volker.armin.hemmann@tu-clausthal.de>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Kuan Luo" <kluo@nvidia.com>
X-OriginalArrivalTime: 14 Apr 2008 08:11:35.0093 (UTC) FILETIME=[27DEC650:01C89E07]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker,
I mean add msleep(x) function between writel(HOST_AHCI_EN, mmio + HOST_CTL) and readl(mmio + HOST_CTL) cause we ever met a bug that writing data to the AHCI BAR5 but need a delay to get correct read back value. But forget it, looks like it's not the same case here.
Which mode do you set(ahci or non-raid) when you encountered the issue that the AHCI_EN bit failed to set? I found we have workaround for AHCI_EN bit setting in our Bios programming guide for AHCI mode.

BRs
Peer Chen

-----Original Message-----
From: Volker Armin Hemmann [mailto:volker.armin.hemmann@tu-clausthal.de] 
Sent: Monday, April 14, 2008 2:42 PM
To: Peer Chen
Cc: Jeff Garzik; Tejun Heo; linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; Kuan Luo
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3

On Montag, 14. April 2008, Peer Chen wrote:
> Volker,
> Could you add a delay between setting AHCI_EN and reading back function?
>

if you tell me how to?

Glück Auf
Volker

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
