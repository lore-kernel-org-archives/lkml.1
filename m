Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbXKHOLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbXKHOLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXKHOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:11:15 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:36846 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbXKHOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:11:14 -0500
Date: Thu, 8 Nov 2007 09:09:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "dead" CONFIG variables under the include/ directory
Message-ID: <Pine.LNX.4.64.0711080906400.29450@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  based on some recent posts from jiri olsa, i realize i'd forgotten
to scan the include/ directory and subdirectories for references to
non-existent CONFIG variables, so i've updated the wiki page here:

  http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

with a detailed scan of include/.  here's the abridged listing -- the
full grep results are at the wiki page:

 asm-arm
    CHRONTEL_7003
    CPU_S3C2400
    CPU_S3C2413
    PCI_HOST_ITE8152
    SA1101
    SMALL_TASKS
 asm-blackfin
    FLASH_SPEED_BHT
    MEM_MT46V32M16
    MEM_MT48LC16M8A2TG_75
 asm-cris
    ETRAX_ARCH_V32
    ETRAXFS_SIM
    SHARE_SHLIB_CORE
 asm-frv
    CONTIGUOUS_PAGE_ALLOC
 asm-m32r
    CHIP_XNUX2
    CHIP_XNUX2_MP
    CHIP_XNUX_MP
    PLAT_M32700UT_Alpha
 asm-m68k
    GG2
 asm-m68knommu
    CFV240
    DISKtel
    M5204
    M68332
 asm-mips
    MSP_FPGA
    MTD_PB1550_BOOT
    MTD_PB1550_USER
    SGI_IP35
    SIBYTE_PT1120
    SIBYTE_PT1125
 asm-powerpc
    403
    SOUND_CS4232
 asm-ppc
    EVB64260
    HYMOD
 asm-sh
    CPU_SUBTYPE_SH7727
 asm-v850
    SMC91111
    V850E2_V850E2S
 asm-x86
    AS_CFI
    AS_CFI_SIGNAL_FRAME
    IOMMU
    PENTIUM4
    UNWIND_INFO
 linux
    BUFFER_DEBUG
    COBALT_MICRO_SERVER
    HARD_PPS
    HAS_COMPAT_EPOLL_EVENT
    IP_NF_NAT_NEEDED
    SA1100_CT6001
 sound
    SND_CS46XX_DEBUG_GPIO
    USE_VXLOADER

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
