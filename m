Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbYEGQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbYEGQEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbYEGQEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:04:37 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:13684 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758174AbYEGQEe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:04:34 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] [PATCH 04/56] microblaze_v2: Open firmware files
Date: Wed, 7 May 2008 09:04:09 -0700
In-reply-to: <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] [PATCH 04/56] microblaze_v2: Open firmware files
Thread-Index: AciwGKrZKBWV82kbTV+Urwf5XO0QtQAQtK/g
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>
Cc: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <john.williams@petalogix.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <grant.likely@secretlab.ca>, "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 07 May 2008 16:04:31.0777 (UTC) FILETIME=[09316110:01C8B05C]
Message-Id: <20080507160432.93FC11750046@mail35-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_PPC_PSERIES
> +#include <asm/rtas.h>
> +#include <asm/kdump.h>
> +#include <asm/smp.h>
> +#include <asm/iommu.h>
> +#include <asm/btext.h>
> +#include <asm/machdep.h>
> +#include <asm/pSeries_reconfig.h>
> +#include <asm/phyp_dump.h>
> +#include <asm/kexec.h>
> +#endif

I don't think we need CONFIG_PPC_PSERIES (multiple times)

> +#ifdef CONFIG_PPC64
> +int __initdata iommu_is_off;
> +int __initdata iommu_force_on;
> +unsigned long tce_alloc_start, tce_alloc_end;
> +#endif

or PPC64 (multiple times

> +#ifdef CONFIG_PPC32

or PPC32

Steve


