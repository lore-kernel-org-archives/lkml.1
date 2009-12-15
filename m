Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZLONBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZLONBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759164AbZLONBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:01:45 -0500
Received: from smtp.nokia.com ([192.100.105.134]:53111 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbZLONBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:01:43 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: origin tree build failure
Date: Tue, 15 Dec 2009 15:01:27 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo; KDE/4.3.4; i686; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <20091215164108.45c9d766.sfr@canb.auug.org.au>
In-Reply-To: <20091215164108.45c9d766.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912151501.27582.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 15 Dec 2009 13:01:29.0192 (UTC) FILETIME=[B78B2680:01CA7D86]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday 15 December 2009 07:41:08 ext Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/mfd/twl4030-codec.c:29:31: error: linux/i2c/twl4030.h: No such file
>  or directory
> 
> (there were more, but I assume that they all stem form this one).
> 
> Caused by commit 0b83ddebc6e884dc0221358cf68c461520fbdd8e ("MFD: twl4030:
> add twl4030_codec MFD as a new child to the core") from Linus' tree
> interacting with commit b07682b6056eb6701f8cb86aa5800e6f2ea7919b ("mfd:
> Rename twl4030* driver files to enable re-use") also from Linus' tree.
> This file seems to have been missed in the renaming.

Yes, the twl4030-codec MFD driver went in earlier than the twl4030 rename patch, 
which does not taken care of the twl4030-codec MFD driver for some reasons.

The patch looks good, I might also align the twl4030-codec MFD driver with the 
renamed twl core soon.
I have to check the feasibility of this first, since the renaming was done to 
facilitate the addition of twl6030 (OMAP4 companion chip), and I don't have yet 
access to the documentation.

Thank you,
Péter
