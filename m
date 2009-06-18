Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbZFRQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbZFRQaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZFRQaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:30:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbZFRQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:30:05 -0400
Message-ID: <4A3A4856.3080306@zytor.com>
Date: Thu, 18 Jun 2009 06:59:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 12/16] x86, mce: squash mce_intel.c into therm_throt.c
References: <4A3601BF.2000201@jp.fujitsu.com> <4A3605A2.6000206@jp.fujitsu.com>	 <851fc09e0906172249q40c99fc6n26662b533b063b9e@mail.gmail.com>	 <4A39ED3B.2060800@jp.fujitsu.com> <851fc09e0906180100n27c0a80ej1fb12a5cabac21b0@mail.gmail.com>
In-Reply-To: <851fc09e0906180100n27c0a80ej1fb12a5cabac21b0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
>>
>> You can pull out "codes may not be shared" from therm_throt.c and
>> put it again into mce_intel.c (that was mce_intel_64.c).  But I
>> believe it is not needed now, until another code is available.
>> Or you can rename therm_throt.c to thermal_intel.c or so for a while.
> 
> I think thermal_intel.c is better.
> 

Actually intel_thermal.c and intel_cmci.c would probably be the right
naming.  The mce_ prefix for files in this directory is redundant; so
for vendor-specific features the vendor is the higher order organizing
factor.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

