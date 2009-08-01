Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZHACZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZHACZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 22:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZHACZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 22:25:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:6725 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZHACZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 22:25:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,305,1246863600"; 
   d="scan'208";a="435229552"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>, Dave Airlie <airlied@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Fri, 31 Jul 2009 19:28:30 -0700
Subject: RE: [Bug #13667] drm: display arifacts when X.Org is stopped
Thread-Topic: [Bug #13667] drm: display arifacts when X.Org is stopped
Thread-Index: AcoRCp83qKxmZj2OSXyHG9Ww5yhUVQBRPaGg
Message-ID: <7E82351C108FA840AB1866AC776AEC466D66A552@orsmsx505.amr.corp.intel.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
 <200907251833.42598.elendil@planet.nl>
 <21d7e9970907300340t79e063e1n18cdba11538c2fdc@mail.gmail.com>
 <200907301341.01693.elendil@planet.nl>
In-Reply-To: <200907301341.01693.elendil@planet.nl>
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
>From: Frans Pop [mailto:elendil@planet.nl] 
>Sent: Thursday, July 30, 2009 4:41 AM
>To: Dave Airlie
>Cc: Rafael J. Wysocki; Linux Kernel Mailing List; Kernel 
>Testers List; Siddha, Suresh B; Pallipadi, Venkatesh
>Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
>
>On Thursday 30 July 2009, Dave Airlie wrote:
>> On Sun, Jul 26, 2009 at 2:33 AM, Frans Pop<elendil@planet.nl> wrote:
>> > On Thursday 09 July 2009, Frans Pop wrote:
>> >> > However we shall endeavour to fix this issues as it may be
>> >> > systemic of something else going wrong in the new PAT/AGP code.
>> >>
>> >> Great. Thanks in advance, I do appreciate it.
>> >
>> > Any news on this?
>>
>> http://git.infradead.org/users/dwmw2/iommu-agp.git
>>
>> don't suppose you could pull that tree in and see if it helps?
>
>Sure I can :-)
>I merged its master branch on top of current mainline + some 
>local patches 
>I have. But I'm afraid it does not make any difference.
>
>Note that I also added Venki's PAT patch set for .32 [1] in my local 
>patches because of this issue, but that does not make any difference 
>either.
>

Can you please check whether the patch here helps?
http://bugzilla.kernel.org/show_bug.cgi?id=13884

Thanks,
Venki