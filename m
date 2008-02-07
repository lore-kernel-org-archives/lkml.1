Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbYBGSHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbYBGSHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbYBGSG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:06:57 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:45454 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbYBGSG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:06:56 -0500
Message-ID: <47AB48B0.10403@qualcomm.com>
Date: Thu, 07 Feb 2008 10:06:40 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Pavel Machek <pavel@ucw.cz>, e1000-devel@lists.sourceforge.net,
       jesse.brandeburg@intel.com, kernel list <linux-kernel@vger.kernel.org>,
       john.ronciak@intel.com, jeffrey.t.kirsher@intel.com
Subject: Re: [E1000-devel] e1000 1sec latency problem
References: <20080207141718.GA2030@elf.ucw.cz> <47AB38AB.8050001@qualcomm.com> <47AB3EEF.6050005@intel.com>
In-Reply-To: <47AB3EEF.6050005@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Max Krasnyansky wrote:
>> So you don't think it's related to the interrupt coalescing by any chance ?
>> I'd suggest to try and disable the coalescing and see if it makes any difference.
>> We've had lots of issues with coalescing misbehavior. Not this bad (ie 1 second) though.
>>
>> Add this to modprobe.conf and reload e1000 module
>>
>> options e1000 RxIntDelay=0,0 RxAbsIntDelay=0,0 InterruptThrottleRate=0,0 TxIntDelay=0,0 TxAbsIntDelay=0,0
> 
> that can't be the problem. irq moderation would only account for 2-3ms variance
> maximum.
Oh, I've definitely seen worse than that. Not as bad as a 1second though. Plus you're talking
about the case when coalescing logic is working as designed ;-). What if there is some kind of 
bug where timer did not expire or something.

Max
