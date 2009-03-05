Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZCEBCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZCEBCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZCEBC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:02:28 -0500
Received: from proofpoint1.lanl.gov ([204.121.3.25]:56069 "EHLO
	proofpoint1.lanl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZCEBC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:02:28 -0500
X-Greylist: delayed 2400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2009 20:02:28 EST
X-NIE-2-Virus-Scanner: amavisd-new at mailrelay1.lanl.gov
Message-ID: <49AF1B16.5000907@lanl.gov>
Date: Wed, 04 Mar 2009 17:21:42 -0700
From: "Marcus G. Daniels" <mdaniels@lanl.gov>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-mtd@lists.infradead.org,
       Vivien Chappelier <vivien.chappelier@free.fr>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [Cbe-oss-dev] [PATCH/RFC] ps3/block: Add ps3vram-ng driver for
 accessing video RAM as block device
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.7400:2.4.4,1.2.40,4.0.166 definitions=2009-03-04_11:2009-02-26,2009-03-04,2009-03-04 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Ideally, we think it would be best if the existing MTD-based ps3vram driver
> would be replaced by the new block-based ps3vram driver before 2.6.29 is
> released. This would relieve the burden of supporting two different swap space
> schemes on PS3 (swap on /dev/mtdblock0 vs. /dev/ps3vram) from the distro
> maintainer's shoulders, as in that case there would never have been a stable
> kernel version containing the MTD-based ps3vram driver.
> [..]
>   - ps3vram-ng is faster than ps3vram:
>       o 1 MiB blocks: +50% (read), +5% (write)
>       o 4 KiB blocks: +50% (read), +5% (write)
>       o 512 B blocks: +10% (read), +10% (write)
>   
Fwiw, it's a useful swap device, since space is so limited -- the 
performance improvements are certainly appealing too.

Marcus
