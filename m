Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZCESYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZCESYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZCESYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:24:09 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:55890 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbZCESYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:24:07 -0500
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 13:24:07 EST
X-RZG-AUTH: :J2kWe0WkPv545sKwvmDa8F87Ow0FrfkUzFK9zKBxnWKSUUKz5RR63w==
X-RZG-CLASS-ID: mo05
Date: Thu, 5 Mar 2009 19:12:37 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-mtd@lists.infradead.org,
       Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing
	video RAM as block device
Message-ID: <20090305181237.GA7355@aepfle.de>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <AA44F8E7-5FBC-4378-A86D-C094ECABD625@aepfle.de> <alpine.LRH.2.00.0903050856490.26681@vixen.sonytel.be> <alpine.LRH.2.00.0903051123240.2618@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903051123240.2618@vixen.sonytel.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, Geert Uytterhoeven wrote:

> On Thu, 5 Mar 2009, Geert Uytterhoeven wrote:
> > On Thu, 5 Mar 2009, Olaf Hering wrote:
> > > I see our old mtddriver does not have modalias support for autoloading.
> > 
> > You forgot to backport commit 0a2d15b928e0b1673d4ed5f48d95af211b6fcc06
> > ("mtd/ps3vram: Add modalias support to the ps3vram driver") to the openSuSE
> > tree?
> 
> Or do you mean that udev doesn't load mtdblock automatically?

I have not tried current kernels.
Our older versions of mtd based ps3vram do not have the autoloading feature.

So, please merge the block based ps3vram.ko.

Thanks for pushing it into mainline.

Olaf
