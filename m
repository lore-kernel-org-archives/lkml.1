Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbXEXKob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbXEXKob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXEXKoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:44:23 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33832 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbXEXKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:44:22 -0400
Message-ID: <46556C85.8050204@s5r6.in-berlin.de>
Date: Thu, 24 May 2007 12:44:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Andrew Paprocki <andrew.m.paprocki@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 amd64 slab allocator bug reported at boot time
References: <76366b180705231851k42eba520jb07113a669c1e598@mail.gmail.com>
In-Reply-To: <76366b180705231851k42eba520jb07113a669c1e598@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Paprocki wrote:
...
> BUG: at /usr/src/linux-2.6.22-rc2/mm/slab.c:777 __find_general_cachep()
> 
> Call Trace:
>  [<ffffffff802743dc>] __kmalloc+0x3e/0xbe
>  [<ffffffff8021d65f>] cache_k8_northbridges+0x7f/0xf0
>  [<ffffffff8052bb53>] gart_iommu_init+0x13/0x4f8
>  [<ffffffff802d15e1>] kobject_shadow_add+0xef/0x1a2
>  [<ffffffff802d13fb>] kobject_get+0x12/0x17
>  [<ffffffff8033b2a4>] class_register+0x10a/0x13d
>  [<ffffffff80527964>] pci_iommu_init+0x9/0x12
...

This is a known "zero allocation" problem, patch available.
http://kernelnewbies.org/known_regressions#line-249
-- 
Stefan Richter
-=====-=-=== -=-= ==---
http://arcgraph.de/sr/
