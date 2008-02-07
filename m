Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbYBGSOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbYBGSOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYBGSOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:14:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:56496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbYBGSOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:14:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,316,1199692800"; 
   d="scan'208";a="257023518"
Message-ID: <47AB49F3.301@intel.com>
Date: Thu, 07 Feb 2008 10:12:03 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Pavel Machek <pavel@ucw.cz>, e1000-devel@lists.sourceforge.net,
       jesse.brandeburg@intel.com, kernel list <linux-kernel@vger.kernel.org>,
       john.ronciak@intel.com, jeffrey.t.kirsher@intel.com
Subject: Re: [E1000-devel] e1000 1sec latency problem
References: <20080207141718.GA2030@elf.ucw.cz> <47AB38AB.8050001@qualcomm.com> <47AB3EEF.6050005@intel.com> <47AB48B0.10403@qualcomm.com>
In-Reply-To: <47AB48B0.10403@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> Kok, Auke wrote:
>> Max Krasnyansky wrote:
>>> So you don't think it's related to the interrupt coalescing by any chance ?
>>> I'd suggest to try and disable the coalescing and see if it makes any difference.
>>> We've had lots of issues with coalescing misbehavior. Not this bad (ie 1 second) though.
>>>
>>> Add this to modprobe.conf and reload e1000 module
>>>
>>> options e1000 RxIntDelay=0,0 RxAbsIntDelay=0,0 InterruptThrottleRate=0,0 TxIntDelay=0,0 TxAbsIntDelay=0,0
>> that can't be the problem. irq moderation would only account for 2-3ms variance
>> maximum.
> Oh, I've definitely seen worse than that. Not as bad as a 1second though. Plus you're talking
> about the case when coalescing logic is working as designed ;-). What if there is some kind of 
> bug where timer did not expire or something.

we don't use a software timer in e1000 irq coalescing/moderation, it's all in
hardware, so we don't have that problem at all. And I certainly have never seen
anything you are referring to with e1000 hardware, and I do not know of any bug
related to this.

are you maybe confused with other hardware?

feel free to demonstrate an example...

Cheers,

Auke
