Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYAYIn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYAYIn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYAYIEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:04:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:62795 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759082AbYAYIES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:04:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,249,1199692800"; 
   d="scan'208";a="371142923"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH]PCIE ASPM support - takes 3
Date: Fri, 25 Jan 2008 16:01:32 +0800
Message-ID: <FC1D1B23302A22499C60C967336B2AE0024F0A74@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <20080124172258.GA5447@ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]PCIE ASPM support - takes 3
Thread-Index: AchfIrxIeAS6vWJrTea4Y44q0zyudgABYovA
References: <1200621388.8965.3.camel@sli10-desk.sh.intel.com> <20080124172258.GA5447@ucw.cz>
From: "Li, Shaohua" <shaohua.li@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "lkml" <linux-kernel@vger.kernel.org>,
       "linux-pci" <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Greg KH" <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Matthew Wilcox" <matthew@wil.cx>
X-OriginalArrivalTime: 25 Jan 2008 08:01:40.0062 (UTC) FILETIME=[84283FE0:01C85F28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
>Hi!
>
>> v3->v2, fixed the issues Matthew Wilcox raised.
>>
>> PCI Express ASPM defines a protocol for PCI Express components in the
D0
>> state to reduce Link power by placing their Links into a low power
state
>> and instructing the other end of the Link to do likewise. This
>> capability allows hardware-autonomous, dynamic Link power reduction
>> beyond what is achievable by software-only controlled power
management.
>> However, The device should be configured by software appropriately.
>> Enabling ASPM will save power, but will introduce device latency.
>
>How big is the latency? 1msec? 10msec? 100usec?
Haven't accurate number, but in one device, it declaims L0s latency is <
128ns, L1 latency is < 64us.

Thanks,
Shaohua
