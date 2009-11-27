Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZK0GEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZK0GEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZK0GEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:04:09 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:55341 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZK0GEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:04:08 -0500
Message-ID: <4B0F6B7E.8000904@oracle.com>
Date: Thu, 26 Nov 2009 22:02:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 26 (kexec/percpu/non-SMP)
References: <20091126203837.b64fb4d3.sfr@canb.auug.org.au>
In-Reply-To: <20091126203837.b64fb4d3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B0F6BD3.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20091125:

in drivers/base/cpu.c, when CONFIG_SMP=n, per_cpu_ptr_to_phys() is not available
(inside #ifdef CONFIG_KEXEC):

in function show_crash_notes():

	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));



drivers/base/cpu.c:100: error: implicit declaration of function 'per_cpu_ptr_to_phys'
-- 
~Randy
