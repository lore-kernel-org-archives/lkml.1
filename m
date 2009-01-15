Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbZAOLWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbZAOLWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZAOLWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:22:10 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:33491 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZAOLWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:22:08 -0500
Date: Thu, 15 Jan 2009 12:20:01 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, catalin.marinas@arm.com, penberg@cs.helsinki.fi
Subject: Re: [BUILD_FAILURE] next-20090115 - s390x - mm/kmemleak.c
Message-ID: <20090115112001.GC5093@osiris.boeblingen.de.ibm.com>
References: <20090115170415.3edc1df6.sfr@canb.auug.org.au> <20090115103504.GA5178@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115103504.GA5178@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 04:05:04PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> 	next-20090115 allyesconfig build fails on s390x
> 
> mm/built-in.o: In function `kmemleak_scan':
> mm/kmemleak.c:977: undefined reference to `_sdata'
> make: *** [.tmp_vmlinux1] Error 1

A lot of architectures don't have _sdata definined in their linker scripts.
On s390 _sdata would be the same as _etext. But that is not necessarily true
for all architectures.
