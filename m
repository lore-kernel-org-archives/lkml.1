Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYHGULt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYHGULt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYHGULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:11:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbYHGULj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:11:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Huemer <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.27-rc1 mtrr fixes do not work
Date: Thu, 7 Aug 2008 22:14:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <4899AF8E.20105@sbg.ac.at>
In-Reply-To: <4899AF8E.20105@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072214.28922.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs.]

On Wednesday, 6 of August 2008, Alexander Huemer wrote:
> hi,
> 
> mtrr is wrong on my machine. the fixes of 2.6.27-rc1 do not seem to work.
> bios is the newest version, mainboard vendor says it's not their fault.
> mainboard is tyan i5000pw.
> please tell me how i can help and cc me on answers, i am not subscribed.
> 
> here is some data:
> 
> seaburg ~ # grep -E "(^\(WW\)|^\(EE\)|^\(NI\)|^\(??\))" /var/log/Xorg.0.log
> (WW) VESA(0): Failed to set up write-combining range (0xd8000000,0x2000000)
> seaburg ~ # dmesg|grep mtrr
> Command line: root=/dev/sda1 video=uvesafb:1280x1024-24@97,mtrr:3,ywrap 
> mtrr_gran_size=64m mtrr_chunk_size=1024m
> Kernel command line: root=/dev/sda1 
> video=uvesafb:1280x1024-24@97,mtrr:3,ywrap mtrr_gran_size=64m 
> mtrr_chunk_size=1024m
> mtrr: type mismatch for d8000000,800000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,400000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,200000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,100000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,80000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,40000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,20000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,10000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,8000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,4000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,2000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,1000 old: write-back new: write-combining
> mtrr: type mismatch for d8000000,2000000 old: write-back new: 
> write-combining
> seaburg ~ # cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=197632MB: write-back, count=1
> reg02: base=0x100000000 (4096MB), size=197632MB: write-back, count=1
> seaburg ~ # grep MemTotal /proc/meminfo
> MemTotal:      4041308 kB
> seaburg ~ # lspci -v | grep -A10 VGA
> 20:05.0 VGA compatible controller: XGI Technology Inc. (eXtreme Graphics 
> Innovation) Volari Z7 (prog-if 00 [VGA controller])
>         Subsystem: XGI Technology Inc. (eXtreme Graphics Innovation) 
> Volari Z7
>         Flags: 66MHz, medium devsel
>         BIST result: 00
>         Memory at d8000000 (32-bit, prefetchable) [size=64M]
>         Memory at dc300000 (32-bit, non-prefetchable) [size=256K]
>         I/O ports at 3000 [size=128]
>         Capabilities: [40] Power Management version 2
> 
> seaburg ~ # zcat /proc/config.gz | grep MTRR
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> seaburg ~ # uname -a
> Linux seaburg 2.6.27-rc1-blackbit #3 SMP Wed Aug 6 00:34:51 CEST 2008 
> x86_64 Intel(R) Xeon(R) CPU E5420 @ 2.50GHz GenuineIntel GNU/Linux
> seaburg ~ #
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


