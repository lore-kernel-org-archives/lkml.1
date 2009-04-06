Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZDFSjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZDFSjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZDFSiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:38:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:25004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZDFSix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:38:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="445474571"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 6 Apr 2009 11:40:40 -0700
Subject: RE: 2.6.29 git master and PAT problems
Thread-Topic: 2.6.29 git master and PAT problems
Thread-Index: Acm2zZfiTcSBd2s/RbK95Tm5pOj3UgAGNT/w
Message-ID: <7E82351C108FA840AB1866AC776AEC46581EDD3D@orsmsx505.amr.corp.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com>
	 <200903302331.10995.a.miskiewicz@gmail.com>
	 <1238449555.4529.1095.camel@localhost.localdomain>
	 <200903310031.10335.a.miskiewicz@gmail.com>
	 <20090331002815.GB10490@linux-os.sc.intel.com>
	 <20090402004933.GE10490@linux-os.sc.intel.com>
	 <5a4c581d0904030253v44294f1bo1c65e89a3db9ae9b@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC4658074803@orsmsx505.amr.corp.intel.com>
 <5a4c581d0904060837q6315fee6i368038d383dfadd@mail.gmail.com>
In-Reply-To: <5a4c581d0904060837q6315fee6i368038d383dfadd@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Alessandro Suardi [mailto:alessandro.suardi@gmail.com] 
>Sent: Monday, April 06, 2009 8:37 AM
>To: Pallipadi, Venkatesh
>Cc: Arkadiusz Miskiewicz; Siddha, Suresh B; 
>linux-kernel@vger.kernel.org; Jesse Barnes
>Subject: Re: 2.6.29 git master and PAT problems
>
>On Fri, Apr 3, 2009 at 3:59 PM, Pallipadi, Venkatesh
><venkatesh.pallipadi@intel.com> wrote:
>>
>> The patch here should get rid of the below msgs.
>> http://marc.info/?l=linux-kernel&m=123862741914199&w=2
>>
>> Can you please test and check whether that resolves the problems?
>>
>> The patch inline in this mail above was a test patch to debug the
>> another problem that only happens with recent X and that one we
>> are still debugging. So you can ignore the above patch for now.
>>
>>
>> Thanks,
>> Venki
>
>Thanks Venki - the messages are gone, but I appear to be far from
> having my graphical environment problems fixed...
>
>- I still get
>
>Apr  6 11:59:39 localhost kernel: [drm] Initialized drm 1.1.0 20060810
>Apr  6 11:59:39 localhost kernel: pci 0000:00:02.0: PCI INT A -> GSI
>16 (level, low) -> IRQ 16
>Apr  6 11:59:39 localhost kernel: mtrr: type mismatch for
>e0000000,10000000 old: write-back new: write-combining
>Apr  6 11:59:39 localhost kernel: [drm] MTRR allocation failed.
>Graphics performance may suffer.
>Apr  6 11:59:39 localhost kernel: [drm] Initialized i915 1.6.0
>20080730 for 0000:00:02.0 on minor 0
>Apr  6 11:59:39 localhost kernel: mtrr: type mismatch for
>e0000000,10000000 old: write-back new: write-combining
>
>- I can't switch from X to VT (Alt-Fn) as my screen gets blank, no
> Caps Lock key led flashing when I hit the key, nothing else than a
> poweroff works
>
>- I can't exit from X to VT as my screen gets flashing and scrolls
> what appears to be a prompt on the top of the screen instead of
> the bottom
>
>F10 kernels behave the same way. 2.6.29.1 as well. Will test
> 2.6.28 or earlier and report in a separate thread with full
> config details.
>

Also test with and without CONFIG_DRM_* for your graphics card.

MTRR messages looks like are due to the conflict between BIOS MTRR
setting and what X is trying to set. Booting into run level 3 and
output of cat /proc/mtrr would be useful data as well.

Thanks,
Venki