Return-Path: <linux-kernel-owner+w=401wt.eu-S935163AbZJOTSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163AbZJOTSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762990AbZJOTSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:18:31 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:30136 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762988AbZJOTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:18:30 -0400
Date: Thu, 15 Oct 2009 12:17:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 15 (i7core_edac)
Message-Id: <20091015121720.57710ad2.randy.dunlap@oracle.com>
In-Reply-To: <20091015152538.74a1cb15.sfr@canb.auug.org.au>
References: <20091015152538.74a1cb15.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AD7754F.009B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 15:25:38 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20091014:


Hi Mauro,

i7core_edac has a few glitches when building on X86_32 or on SMP=n.
Should it be restricted to X86_64 and SMP=y?


drivers/edac/i7core_edac.c:860: error: implicit declaration of function 'msleep'
--> #include <linux/delay.h>

SMP=n:
drivers/edac/i7core_edac.c:1700: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'


X86_32=y:
drivers/edac/i7core_edac.c:919: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:922: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:924: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:929: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:932: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:934: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:939: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:945: warning: left shift count >= width of type
drivers/edac/i7core_edac.c:951: warning: left shift count >= width of type

---
~Randy
