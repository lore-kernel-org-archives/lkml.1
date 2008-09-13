Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYIMAZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYIMAZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYIMAZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:25:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:55189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384AbYIMAZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:25:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,392,1217833200"; 
   d="scan'208";a="45765360"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Fri, 12 Sep 2008 17:24:56 -0700
Subject: RE: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
 and VESA framebuffer
Thread-Topic: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
 and VESA framebuffer
Thread-Index: AckU3D2vlnfUJ8Y6TtWmO5jBVGUsywAFBigwABGeMJA=
Message-ID: <7E82351C108FA840AB1866AC776AEC462CA8E8B0@orsmsx505.amr.corp.intel.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
 <200809121254.02307.elendil@planet.nl>
 <7E82351C108FA840AB1866AC776AEC462C9BAFC5@orsmsx505.amr.corp.intel.com>
 <200809121533.43318.elendil@planet.nl> 
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
>From: Pallipadi, Venkatesh
>
>>-----Original Message-----
>>From: Frans Pop [mailto:elendil@planet.nl]
>>Sent: Friday, September 12, 2008 6:34 AM
>>
>>
>>I've attached that file and dmesg output for two of the machines.
>>
>
>OK. This is the same issue as the one on this thread here
>http://www.ussg.iu.edu/hypermail/linux/kernel/0808.2/1532.html
>
>
>We have too many entires in PAT list due to RAM pages being marked
>UC by drivers. Unfortunately, there are no quick fixes that can fix
>this for 2.6.27. However, we are aware of the problem here and
>working on a more complete fix for this. We should have the patch
>for it soon.
>

Can you try the patch here
http://www.ussg.iu.edu/hypermail/linux/kernel/0809.1/2074.html
And report back whether that resolves the issue.

Thanks,
Venki
