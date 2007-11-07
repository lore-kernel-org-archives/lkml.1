Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbXKGUaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbXKGUaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXKGUaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:30:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:42319 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbXKGUaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:30:11 -0500
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 powerpc - axon_msi
	build faliure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <47321763.4050802@linux.vnet.ibm.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	 <47321763.4050802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 08 Nov 2007 07:28:43 +1100
Message-Id: <1194467323.6523.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-08 at 01:22 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel build fails with randconfig, with folllowing error

Why cares about randconfig crap ? I don't much. Especially not if you
don't provide the actual config that triggered the error.

>   CC      arch/powerpc/platforms/cell/axon_msi.o
> arch/powerpc/platforms/cell/axon_msi.c:69: error: expected specifier-qualifier-list before ‘dcr_host_t’
> arch/powerpc/platforms/cell/axon_msi.c: In function ‘msic_dcr_write’:
> arch/powerpc/platforms/cell/axon_msi.c:80: error: implicit declaration of function ‘dcr_write’
> arch/powerpc/platforms/cell/axon_msi.c:80: error: ‘struct axon_msic’ has no member named ‘dcr_host’
> arch/powerpc/platforms/cell/axon_msi.c: In function ‘axon_msi_cascade’:
> arch/powerpc/platforms/cell/axon_msi.c:89: error: implicit declaration of function ‘dcr_read’
> arch/powerpc/platforms/cell/axon_msi.c:89: error: ‘struct axon_msic’ has no member named ‘dcr_host’
> arch/powerpc/platforms/cell/axon_msi.c:95: error: ‘struct axon_msic’ has no member named ‘read_offset’
> arch/powerpc/platforms/cell/axon_msi.c:96: error: ‘struct axon_msic’ has no member named ‘read_offset’
> arch/powerpc/platforms/cell/axon_msi.c:101: error: ‘struct axon_msic’ has no member named ‘read_offset’
> arch/powerpc/platforms/cell/axon_msi.c:103: error: ‘struct axon_msic’ has no member named ‘read_offset’
> arch/powerpc/platforms/cell/axon_msi.c:104: error: ‘struct axon_msic’ has no member named ‘read_offset’
> arch/powerpc/platforms/cell/axon_msi.c: In function ‘axon_msi_notify_reboot’:
> arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
> arch/powerpc/platforms/cell/axon_msi.c:301: warning: type defaults to ‘int’ in declaration of ‘__mptr’
> arch/powerpc/platforms/cell/axon_msi.c:301: warning: initialization from incompatible pointer type
> arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
> arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
> arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
> arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
> arch/powerpc/platforms/cell/axon_msi.c:301: warning: type defaults to ‘int’ in declaration of ‘__mptr’
> arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
> arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
> arch/powerpc/platforms/cell/axon_msi.c:304: error: ‘struct axon_msic’ has no member named ‘dcr_host’
> arch/powerpc/platforms/cell/axon_msi.c: In function ‘axon_msi_setup_one’:
> arch/powerpc/platforms/cell/axon_msi.c:332: error: implicit declaration of function ‘dcr_resource_start’
> arch/powerpc/platforms/cell/axon_msi.c:333: error: implicit declaration of function ‘dcr_resource_len’
> arch/powerpc/platforms/cell/axon_msi.c:342: error: ‘struct axon_msic’ has no member named ‘dcr_host’
> arch/powerpc/platforms/cell/axon_msi.c:342: error: implicit declaration of function ‘dcr_map’
> arch/powerpc/platforms/cell/axon_msi.c:343: error: implicit declaration of function ‘DCR_MAP_OK’
> arch/powerpc/platforms/cell/axon_msi.c:343: error: ‘struct axon_msic’ has no member named ‘dcr_host’
> arch/powerpc/platforms/cell/axon_msi.c:388: error: ‘struct axon_msic’ has no member named ‘list’
> make[2]: *** [arch/powerpc/platforms/cell/axon_msi.o] Error 1
> make[1]: *** [arch/powerpc/platforms/cell] Error 2
> make: *** [arch/powerpc/platforms] Error 2
> 
> This is because of the #ifdef CONFIG_PPC_DCR in the asm-powerpc/dcr.h.
> 

