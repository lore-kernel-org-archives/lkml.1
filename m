Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYJGWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYJGWbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbYJGWbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:31:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:10260 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbYJGWbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="388772926"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "akataria@vmware.com" <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Tue, 7 Oct 2008 15:30:10 -0700
Subject: RE: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
Thread-Topic: [RFC] CPUID usage for interaction between Hypervisors	and
	Linux.
Thread-Index: AckluaB72BLlsHRcTbeq450OBusaKQAAaQqQ
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15DE4F934@orsmsx505.amr.corp.intel.com>
References: <1222881242.9381.17.camel@alok-dev1>
	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>
	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1>
 <48E3FDD5.7040106@zytor.com>
 <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com>
 <48E422CA.2010606@zytor.com>
 <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com>
 <48E6AB15.8060405@zytor.com>
 <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com>
 <48E6BA5B.2090804@zytor.com>
In-Reply-To: <48E6BA5B.2090804@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m97MVtdq019015

On 10/3/2008 5:35:39 PM, H. Peter Anvin wrote:
> Nakajima, Jun wrote:
> >
> > What's the significance of supporting multiple interfaces to the
> > same guest simultaneously, i.e. _runtime_? We don't want the guests
> > to run on such a literarily Frankenstein machine. And practically,
> > such testing/debugging would be good only for Halloween :-).
> >
>
> By that notion, EVERY CPU currently shipped is a "Frankenstein" CPU,
> since at very least they export Intel-derived and AMD-derived interfaces.
>  This is in other words, a ridiculous claim.

The big difference here is that you could create a VM at runtime (by combining the existing interfaces) that did not exist before (or was not tested before). For example, a hypervisor could show hyper-v, osx-v (if any), linux-v, etc., and a guest could create a VM with hyper-v MMU, osx-v interrupt handling, Linux-v timer, etc. And such combinations/variations can grow exponentially.

Or are you suggesting that multiple interfaces be _available_ to guests at runtime but the guest chooses one of them?

>         -hpa
>
             .
Jun Nakajima | Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
