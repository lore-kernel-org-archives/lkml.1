Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYKRAQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYKRAQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKRAQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:16:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:33832 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYKRAQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:16:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,621,1220252400"; 
   d="scan'208";a="404784412"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 17 Nov 2008 16:16:09 -0800
Subject: RE: [PATCH] x86: Support always running TSC on Intel CPUs
Thread-Topic: [PATCH] x86: Support always running TSC on Intel CPUs
Thread-Index: AclJEpiTpsKYhXYsR6K9jiZV4XazNAAACgMg
Message-ID: <7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com>
References: <20081118001137.GA12350@linux-os.sc.intel.com>
 <492208BE.2000001@zytor.com>
In-Reply-To: <492208BE.2000001@zytor.com>
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
>From: H. Peter Anvin [mailto:hpa@zytor.com] 
>Sent: Monday, November 17, 2008 4:14 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; linux-kernel
>Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
>
>Venki Pallipadi wrote:
>> Add support for CPUID_0x80000007_Bit8 on Intel CPUs as well. 
>This bit means
>> that the TSC is invariant with C/P/T states and always runs 
>at constant
>> frequency.
>> 
>> With Intel CPUs, we have 3 classes
>> * CPUs where TSC runs at constant rate and does not stop n C-states
>> * CPUs where TSC runs at constant rate, but will stop in 
>deep C-states
>> * CPUs where TSC rate will vary based on P/T-states and TSC 
>will stop in deep
>>   C-states.
>> 
>> To cover these 3, one feature bit (CONSTANT_TSC) is not 
>enough. So, add a
>> second bit (NOSTOP_TSC). CONSTANT_TSC indicates that the TSC runs at
>> constant frequency irrespective of P/T-states, and 
>NOSTOP_TSC indicates
>> that TSC does not stop in deep C-states.
>> 
>
>What is the definition of a "deep" C-state?  C2?  C3?  C4?
>
>	-hpa

All C-states higher than C1. 

Thanks,
Venki