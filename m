Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbZLKGrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbZLKGrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbZLKGrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:47:16 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:17283 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbZLKGrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:47:15 -0500
Date: Thu, 10 Dec 2009 22:46:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "werner" <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: max2165 problem / kernel problem   2.6.32-git5
Message-Id: <20091210224659.cb5877d5.randy.dunlap@oracle.com>
In-Reply-To: <web-108998906@zbackend1.aha.ru>
References: <web-108998906@zbackend1.aha.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B21EAF3.0153:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 22:37:03 -0400 werner wrote:

> ref 2.6.32-git5
> 
> 1) max2165 problem:
> 
>    CC      arch/x86/boot/video-bios.o
>    LD      arch/x86/boot/setup.elf
>    OBJCOPY arch/x86/boot/setup.bin
>    OBJCOPY arch/x86/boot/vmlinux.bin
>    HOSTCC  arch/x86/boot/tools/build
>    BUILD   arch/x86/boot/bzImage
> Root device is (8, 1)
> Setup is 13980 bytes (padded to 14336 bytes).
> System is 8663 kB
> CRC c422073c
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>    Building modules, stage 2.
>    MODPOST 2104 modules
> ERROR: "__fixunsdfsi" 
> [drivers/media/common/tuners/max2165.ko] undefined!
> ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] 
> undefined!
> ERROR: "__floatunsidf" 
> [drivers/media/common/tuners/max2165.ko] undefined!
> WARNING: modpost: Found 8 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: [__modpost] Error 1 (ignored)
>    CC      arch/x86/crypto/crc32c-intel.mod.o
>    LD [M]  arch/x86/crypto/crc32c-intel.ko
>    CC      arch/x86/crypto/salsa20-i586.mod.o
> 

Patch for this was merged into the v4l/dvb tree today.
It should show up in mainline fairly soon.

> 
> 
> 2) The kernel problem (s) reported earlier, continue. 
>     Inclusive  the xd  out-of-memory error


---
~Randy
