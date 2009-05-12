Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZELSOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZELSOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZELSOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:14:11 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:5164 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753343AbZELSOK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:14:10 -0400
X-BigFish: VPS-8(zz1432R98dR1805M936fJzz1202hzz3198u327alz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,8,
X-WSS-ID: 0KJJMN5-02-6E4-01
Date: Tue, 12 May 2009 20:13:58 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
	/proc/cpuinfo
Message-ID: <20090512181358.GC19143@aftab>
References: <1242112482.3283.1.camel@localhost.localdomain> <20090512133950.GA15474@aftab> <1242136177.14832.0.camel@ht.satnam> <20090512141027.GA19143@aftab> <4A09A688.6080603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A09A688.6080603@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 May 2009 18:13:58.0085 (UTC) FILETIME=[6B1D6F50:01C9D32D]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 12, 2009 at 09:40:40AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> >>>
> >> why we need cpuid_level ?
> > 
> > It is already visible in userspace. I think you've got an answer to a
> > very similar question already:
> > 
> > http://marc.info/?l=linux-kernel&m=124206571628464
> > 
> 
> extended_cpuid_level should be motivated, but probably does make sense.

I still fail to see the need for adding that to /proc/cpuinfo,
especially if you can do the whole exercise from userspace. But I'm sure
you have a good example.

>  It hardly "completes" /proc/cpuinfo; especially if you consider that
> there are at least three additional ranges in wide use (two used by a
> single vendor only, and the third by virtualization software.)

I think both vendors use the two ranges :-o).

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

