Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZEYOv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZEYOv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZEYOvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:51:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4793 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZEYOvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=FfUybMFO0FVN26R9MbIAFVQsv+VYFDylfM1eLDZWAFUI4CeqAT8XbzLwg9Y6+noUqL
         y7sxGtgwGRfP0kA/8ow6/X19taLlu3Lw+OMbNVlSsULM0Z+TTKUYn5LPZ6qfOWFl3iZE
         wGpuHkMjEfS4C5V3cfASRi7PYJ/aci87frPM0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: =?utf-8?q?=E8=83=A1=E6=B4=AA=E5=85=B5?= <huhb@lemote.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Mon, 25 May 2009 16:56:24 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: yanh@lemote.com, wuzhangjin@gmail.com, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-scsi" <linux-scsi@vger.kernel.org>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com> <1243230339.9819.18.camel@localhost.localdomain> <4A1A4A54.6090401@lemote.com>
In-Reply-To: <4A1A4A54.6090401@lemote.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905251656.25357.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009 09:35:48 胡洪兵 wrote:
> yanh 写道:

[...]

> > the cs5536 pata driver have some geode platform dependent codes. We can
> > just ignore it, but the performance is poor(using hdparm to test it),
> > which only get 22+ MB/s. we find it only use udma2. However if using
> > amd74xx driver, it can set udma5, and the speed can reach to 50+ MB/s. 
> >
> > we will test whether this driver is working well without this patch.
> >
> > Anyway, thanks your advice.
> >   
> Use the driver drivers/ata/pata_cs5536.c, unfortunately it also have the 
> same issue.

Both drivers (pata_cs5536 & cs5536) should handle UDMA5.

Could you please explain the issue with platform specific code a bit more?

Is it related to a cable detection by any chance?

Thanks.
Bart
