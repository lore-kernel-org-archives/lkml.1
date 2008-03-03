Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbYCCRsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbYCCRsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYCCRsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:48:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:23640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYCCRsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:48:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,438,1199692800"; 
   d="scan'208";a="214352421"
Message-ID: <47CC385A.7090300@intel.com>
Date: Mon, 03 Mar 2008 09:41:46 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Phil Oester <kernel@linuxace.com>
CC: Clem Taylor <clem.taylor@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: e1000 driver not loading in 2.6.24.3 on x86_64 (worked in 2.6.24-rc7)
References: <ecb4efd10803011242w3874d27eyb1afaea06766bdbf@mail.gmail.com> <20080301210311.GA10273@linuxace.com>
In-Reply-To: <20080301210311.GA10273@linuxace.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2008 17:42:38.0098 (UTC) FILETIME=[F8DCEF20:01C87D55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Oester wrote:
> On Sat, Mar 01, 2008 at 03:42:58PM -0500, Clem Taylor wrote:
>> I'm trying to move from 2.6.24-rc7 to 2.6.24.3 on a x86_64 desktop
>> machine. With 2.6.24.3, the e1000 driver (compiled in, not a module)
>> does not claim the device. In 2.6.24-rc7 it works just fine.
>>
>> The ethernet device shows up in lspci in both kernels, but the driver
>> doesn't seem to probe the card in 2.6.24.3
>>
>> 2.6.24-rc7:
>> loop: module loaded
>> Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
>> Copyright (c) 1999-2006 Intel Corporation.
>> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
>> PCI: Setting latency timer of device 0000:04:00.0 to 64
>> e1000: 0000:04:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:76:c9:33>
>> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> 
> Note the difference between the above line start (e1000)
> and this one:
> 
>> e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
>> e1000e: Copyright (c) 1999-2007 Intel Corporation.
> 
>> 2.6.24.3:
>> loop: module loaded
> 
> And note the absence of e1000 here:
> 
>> e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
>> e1000e: Copyright (c) 1999-2007 Intel Corporation.
>> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> 
> In other words, you need the e1000 driver but don't have it.

IOW you have a PCI or PCI-X e1000 device, not a PCI Express adapter. right?

Auke


