Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXKGUW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXKGUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXKGUWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:22:18 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:46793 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbXKGUWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:22:16 -0500
Message-ID: <47321763.4050802@linux.vnet.ibm.com>
Date: Thu, 08 Nov 2007 01:22:03 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 powerpc - axon_msi build
 faliure
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails with randconfig, with folllowing error

  CC      arch/powerpc/platforms/cell/axon_msi.o
arch/powerpc/platforms/cell/axon_msi.c:69: error: expected specifier-qualifier-list before ‘dcr_host_t’
arch/powerpc/platforms/cell/axon_msi.c: In function ‘msic_dcr_write’:
arch/powerpc/platforms/cell/axon_msi.c:80: error: implicit declaration of function ‘dcr_write’
arch/powerpc/platforms/cell/axon_msi.c:80: error: ‘struct axon_msic’ has no member named ‘dcr_host’
arch/powerpc/platforms/cell/axon_msi.c: In function ‘axon_msi_cascade’:
arch/powerpc/platforms/cell/axon_msi.c:89: error: implicit declaration of function ‘dcr_read’
arch/powerpc/platforms/cell/axon_msi.c:89: error: ‘struct axon_msic’ has no member named ‘dcr_host’
arch/powerpc/platforms/cell/axon_msi.c:95: error: ‘struct axon_msic’ has no member named ‘read_offset’
arch/powerpc/platforms/cell/axon_msi.c:96: error: ‘struct axon_msic’ has no member named ‘read_offset’
arch/powerpc/platforms/cell/axon_msi.c:101: error: ‘struct axon_msic’ has no member named ‘read_offset’
arch/powerpc/platforms/cell/axon_msi.c:103: error: ‘struct axon_msic’ has no member named ‘read_offset’
arch/powerpc/platforms/cell/axon_msi.c:104: error: ‘struct axon_msic’ has no member named ‘read_offset’
arch/powerpc/platforms/cell/axon_msi.c: In function ‘axon_msi_notify_reboot’:
arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
arch/powerpc/platforms/cell/axon_msi.c:301: warning: type defaults to ‘int’ in declaration of ‘__mptr’
arch/powerpc/platforms/cell/axon_msi.c:301: warning: initialization from incompatible pointer type
arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
arch/powerpc/platforms/cell/axon_msi.c:301: warning: type defaults to ‘int’ in declaration of ‘__mptr’
arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
arch/powerpc/platforms/cell/axon_msi.c:301: error: ‘struct axon_msic’ has no member named ‘list’
arch/powerpc/platforms/cell/axon_msi.c:304: error: ‘struct axon_msic’ has no member named ‘dcr_host’
arch/powerpc/platforms/cell/axon_msi.c: In function ‘axon_msi_setup_one’:
arch/powerpc/platforms/cell/axon_msi.c:332: error: implicit declaration of function ‘dcr_resource_start’
arch/powerpc/platforms/cell/axon_msi.c:333: error: implicit declaration of function ‘dcr_resource_len’
arch/powerpc/platforms/cell/axon_msi.c:342: error: ‘struct axon_msic’ has no member named ‘dcr_host’
arch/powerpc/platforms/cell/axon_msi.c:342: error: implicit declaration of function ‘dcr_map’
arch/powerpc/platforms/cell/axon_msi.c:343: error: implicit declaration of function ‘DCR_MAP_OK’
arch/powerpc/platforms/cell/axon_msi.c:343: error: ‘struct axon_msic’ has no member named ‘dcr_host’
arch/powerpc/platforms/cell/axon_msi.c:388: error: ‘struct axon_msic’ has no member named ‘list’
make[2]: *** [arch/powerpc/platforms/cell/axon_msi.o] Error 1
make[1]: *** [arch/powerpc/platforms/cell] Error 2
make: *** [arch/powerpc/platforms] Error 2

This is because of the #ifdef CONFIG_PPC_DCR in the asm-powerpc/dcr.h.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
