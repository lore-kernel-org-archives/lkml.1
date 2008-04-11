Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYDKJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYDKJvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYDKJvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:51:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.112.145]:7817 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbYDKJvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:51:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Fri, 11 Apr 2008 02:50:54 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Fri, 11 Apr 2008 17:50:09 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B26A20264@hkemmail01.nvidia.com>
In-Reply-To: <47FEFFD6.3070902@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Thread-Index: Acibmi1czufJa3VXQFGlrVKTydN/wgAHSPJA
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803191455.14380.volker.armin.hemmann@tu-clausthal.de> <47F30438.40506@gmail.com> <200804021909.41609.volker.armin.hemmann@tu-clausthal.de> <47F43766.2070207@gmail.com> <15F501D1A78BD343BE8F4D8DB854566B2600DE6E@hkemmail01.nvidia.com> <47FEFFD6.3070902@gmail.com>
From: "Peer Chen" <pchen@nvidia.com>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Volker Armin Hemmann" <volker.armin.hemmann@tu-clausthal.de>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Kuan Luo" <kluo@nvidia.com>
X-OriginalArrivalTime: 11 Apr 2008 09:50:09.0803 (UTC) FILETIME=[6E12A5B0:01C89BB9]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I checked our chipset errata, didn't find any useful information about
SRST and MSI issue of AHCI controller.
Looks like it's related to BIOS because different mode setting in BIOS
result in different behavior, could you point out the BIOS version and
also send me the 'lspci -xxx' dump of AHCI/non-raid mode?
One question, what kind of setting option for AHCI controller in your
BIOS, there are IDE/RAID/AHCI modes for the board of mine, no 'non-raid'
mode. Non-raid mode confuse me.

BRs
Peer Chen

-----Original Message-----
From: Tejun Heo [mailto:htejun@gmail.com] 
Sent: Friday, April 11, 2008 2:06 PM
To: Peer Chen
Cc: Volker Armin Hemmann; linux-kernel@vger.kernel.org;
linux-ide@vger.kernel.org; Kuan Luo
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3

Peer Chen wrote:
> I didn't find this issue on my MCP65 board but my chip revision is
> 0xa3 and yours is 0xa1, I'll try to find if there is any useful
> information between two version chip for this issue.

Any progress?

-- 
tejun
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
