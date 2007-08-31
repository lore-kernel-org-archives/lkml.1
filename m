Return-Path: <linux-kernel-owner+w=401wt.eu-S965174AbXHaLnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174AbXHaLnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXHaLm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:42:59 -0400
Received: from ext-nj2ut-2.online-age.net ([64.14.54.231]:36821 "EHLO
	ext-nj2ut-2.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932675AbXHaLm6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:42:58 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2007 07:42:58 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Section mismatch in 2.6.23-rc4
Date: Fri, 31 Aug 2007 13:35:35 +0200
Message-ID: <62DDBB9E5E23CC4A929EE46F9427CEAF295F33@BUDMLVEM04.e2k.ad.ge.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Section mismatch in 2.6.23-rc4
Thread-Index: AcfrwwuuH2ExcsHvTuO3kHM3y6j3zg==
From: "Hommel, Thomas (GE Indust, GE Fanuc)" <Thomas.Hommel@gefanuc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 31 Aug 2007 11:35:40.0932 (UTC) FILETIME=[0F304440:01C7EBC3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling a kernel, I get the warnings below. 
I am using ARCH=powerpc and 'make mpc8641_hpcn_defconfig', 'make
uImage'. This didn't appear in 2.6.22, but in
arch/powerpc/kernel/head_32.S and setup_32.c, the section info
apparently didn't change. 


  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x18): Section mismatch: reference to
.init.text:early_init (between '__start' and '__after_mmu_off')
WARNING: vmlinux.o(.text+0x3788): Section mismatch: reference to
.init.text:machine_init (between 'start_here' and 'set_context')
WARNING: vmlinux.o(.text+0x3790): Section mismatch: reference to
.init.text:MMU_init (between 'start_here' and 'set_context')
WARNING: vmlinux.o(.text+0x37ba): Section mismatch: reference to
.init.text:start_kernel (between 'start_here' and 'set_context')
WARNING: vmlinux.o(.text+0x37be): Section mismatch: reference to
.init.text:start_kernel (between 'start_here' and 'set_context')
  LD      vmlinux
  SYSMAP  System.map

