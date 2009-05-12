Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZELOLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZELOLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZELOLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:11:03 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:53968 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752329AbZELOLB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:11:01 -0400
X-BigFish: VPS-17(zz1432R98dR936eQ1805M936fJzz1202hzz3198u327alz32i6bh6di)
X-FB-SS: 5,13,
X-WSS-ID: 0KJJBDL-01-SNT-01
Date: Tue, 12 May 2009 16:10:27 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
	/proc/cpuinfo
Message-ID: <20090512141027.GA19143@aftab>
References: <1242112482.3283.1.camel@localhost.localdomain> <20090512133950.GA15474@aftab> <1242136177.14832.0.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242136177.14832.0.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 May 2009 14:10:30.0054 (UTC) FILETIME=[680CCC60:01C9D30B]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 07:19:37PM +0530, Jaswinder Singh Rajput wrote:
> On Tue, 2009-05-12 at 15:39 +0200, Borislav Petkov wrote:
> > Hi,
> > 
> > On Tue, May 12, 2009 at 12:44:42PM +0530, Jaswinder Singh Rajput wrote:
> > > 
> > > Here are 2 patches for adding new field extended_cpuid_level, please
> > > choose PATCH whichever is more appropriate:
> > > 
> > > PATCH 1:
> > > Subject: [PATCH] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo
> > > 
> > > extended_cpuid_level also gives useful information like cpuid_level
> > > and very useful for AMD processors.
> > > 
> > > Adding extended_cpuid_level in /proc/cpuinfo completes cpuid_level info.
> > 
> > and this is needed because... ?!
> > 
> 
> why we need cpuid_level ?

It is already visible in userspace. I think you've got an answer to a
very similar question already:

http://marc.info/?l=linux-kernel&m=124206571628464

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

