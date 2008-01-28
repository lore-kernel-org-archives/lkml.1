Return-Path: <linux-kernel-owner+w=401wt.eu-S1765009AbYA1XXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765009AbYA1XXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764513AbYA1XRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:17:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:15217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764872AbYA1XRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:17:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,263,1199692800"; 
   d="scan'208";a="509385586"
Message-ID: <479E61EA.8000702@intel.com>
Date: Mon, 28 Jan 2008 15:14:50 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH]PCIE ASPM support - takes 3
References: <1200621388.8965.3.camel@sli10-desk.sh.intel.com> <20080124172258.GA5447@ucw.cz>
In-Reply-To: <20080124172258.GA5447@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> v3->v2, fixed the issues Matthew Wilcox raised.
>>
>> PCI Express ASPM defines a protocol for PCI Express components in the D0
>> state to reduce Link power by placing their Links into a low power state
>> and instructing the other end of the Link to do likewise. This
>> capability allows hardware-autonomous, dynamic Link power reduction
>> beyond what is achievable by software-only controlled power management.
>> However, The device should be configured by software appropriately.
>> Enabling ASPM will save power, but will introduce device latency.
> 
> How big is the latency? 1msec? 10msec? 100usec?

the latency is different for each device but the timing is negotiated and the
pci-e spec lists possible timings that can be used. The maximum is (I think...)
64usec but can be as low as 1 or 2 usec.

Auke
