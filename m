Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbZAOMQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbZAOMQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZAOMQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:16:30 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62504 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754111AbZAOMQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:16:29 -0500
Subject: Re: [BUILD_FAILURE] next-20090115 - s390x - mm/kmemleak.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com
In-Reply-To: <20090115121347.GE5093@osiris.boeblingen.de.ibm.com>
References: <20090115170415.3edc1df6.sfr@canb.auug.org.au>
	 <20090115103504.GA5178@linux.vnet.ibm.com>
	 <20090115112001.GC5093@osiris.boeblingen.de.ibm.com>
	 <1232020540.32016.19.camel@pc1117.cambridge.arm.com>
	 <1232021280.11860.0.camel@penberg-laptop>
	 <20090115121347.GE5093@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 15 Jan 2009 12:16:21 +0000
Message-Id: <1232021781.32016.32.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2009 12:16:22.0014 (UTC) FILETIME=[13F811E0:01C9770B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 13:13 +0100, Heiko Carstens wrote:
> On Thu, Jan 15, 2009 at 02:08:00PM +0200, Pekka Enberg wrote:
> > On Thu, 2009-01-15 at 11:55 +0000, Catalin Marinas wrote:
> > > On Thu, 2009-01-15 at 12:20 +0100, Heiko Carstens wrote:
> > > > On Thu, Jan 15, 2009 at 04:05:04PM +0530, Kamalesh Babulal wrote:
> > > > > Hi Stephen,
> > > > > 
> > > > > 	next-20090115 allyesconfig build fails on s390x
> > > > > 
> > > > > mm/built-in.o: In function `kmemleak_scan':
> > > > > mm/kmemleak.c:977: undefined reference to `_sdata'
> > > > > make: *** [.tmp_vmlinux1] Error 1
> > > > 
> > > > A lot of architectures don't have _sdata definined in their linker scripts.
> > > > On s390 _sdata would be the same as _etext. But that is not necessarily true
> > > > for all architectures.
> > > 
> > > Kmemleak has only been tested on ARM and x86. I can add patches for the
> > > other architectures so that the compilation is fine but can't really run
> > > such kernels.
> > 
> > Yeah, but you could just depend on X86 || ARM in Kconfig, no?
> 
> CONFIG_HAVE_KMEMLEAK_SUPPORT ?
> Is there actually more arch specific that needs to be done?
> Haven't checked yet.

Not in the latter kmemleak versions, just the vmlinux.lds _sdata,
_edata, __bss_start, __bss_stop entries.

-- 
Catalin

