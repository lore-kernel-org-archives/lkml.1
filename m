Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZEMG2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZEMG2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZEMG22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:28:28 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:15019
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755836AbZEMG21 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:28:27 -0400
X-BigFish: VPS-29(zz1432R98dR936eQ1805M936fJ4cd6kzz1202hzz5a6ciz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJKKN7-01-ADP-01
Date: Wed, 13 May 2009 08:27:48 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
	Management
Message-ID: <20090513062748.GE9991@alberich.amd.com>
References: <1242142530.2547.11.camel@ht.satnam> <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam> <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242155190.2492.73.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 May 2009 06:28:17.0031 (UTC) FILETIME=[004B1170:01C9D394]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 12:36:30AM +0530, Jaswinder Singh Rajput wrote:
> On Tue, 2009-05-12 at 21:09 +0530, Jaswinder Singh Rajput wrote:
> > Add Advanced Power Management (Function 8000_0007h), edx
> > 
> > /proc/cpuinfo (before)
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> > rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16
> > lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> > 
> > /proc/cpuinfo (after)
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> > rdtscp lm 3dnowext 3dnow rep_good tsc_reliable nonstop_tsc pni cx16
> > lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> > ts ttp htc stc 100mhzsteps hwpstate constant_tsc
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> 
> New patch after adding helper cpufeature for Advanced Power Management
> availability and fixing typo.
> 
> [PATCH -tip] x86: Add cpufeatures for Advanced Power Management
> 
> Add Advanced Power Management (Function 8000_0007h), edx
> 
> /proc/cpuinfo (before)
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16
> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> 
> /proc/cpuinfo (after)
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow rep_good tsc_reliable nonstop_tsc pni cx16
> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> ts ttp htc stc 100mhzsteps hwpstate constant_tsc

What's the point of adding power managment flags twice?
Most of it is already displayed in /proc/cpuinfo under
"power management".


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


