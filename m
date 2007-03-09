Return-Path: <linux-kernel-owner+w=401wt.eu-S1767442AbXCIRfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767442AbXCIRfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767439AbXCIRfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:35:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:11373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767440AbXCIRfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:35:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,268,1170662400"; 
   d="scan'208"; a="55746472:sNHT198943065"
Message-ID: <45F19ACD.6030906@linux.intel.com>
Date: Fri, 09 Mar 2007 20:35:09 +0300
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Pavel Machek <pavel@ucw.cz>, "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
References: <20070302220454.a0c66d04.khali@linux-fr.org>	<B28E9812BAF6E2498B7EC5C427F293A402021B07@orsmsx415.amr.corp.intel.com>	<20070309071855.GA5148@ucw.cz>	<20070309112420.42420cf2.khali@linux-fr.org>	<45F13965.2030709@linux.intel.com> <20070309182355.d1845962.khali@linux-fr.org>
In-Reply-To: <20070309182355.d1845962.khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Alexey,
>
> On Fri, 09 Mar 2007 13:39:33 +0300, Alexey Starikovskiy wrote:
>   
>> Jean Delvare wrote:
>>     
>>> I can only second Pavel's wish here. This would be highly convenient
>>> for OS developers to at least know which resources are accessed by AML
>>> and SMM. Without this information, we can never be sure that OS-level
>>> code won't conflict with ACPI or SMM.
>>>       
>> BIOS vendors are not required to support latest and greatest ACPI spec. 
>> So even if some future spec version
>> will include this ports description, we will still have majority of 
>> hardware not exporting it...
>>     
>
> Your reasoning is amazing. So we should refrain from proposing any
> improvement which we aren't certain 100% of the systems will support
> tomorrow? Then let's all stay away from our keyboards forever, as the
> evolution of computer technology is based on exactly that -
> improvements which not all systems implement.
>
> It's friday evening, let's have some more for fun. With a similar
> logic, ten years ago we'd have come up with the following conclusions:
>
> The majority of computers have a single CPU, there is no point in
> adding SMP support to Linux.
>
> Let's not add a new instruction set in our next CPU family. The
> majority of systems will not implement it so it will be useless anyway.
>
> There's no point in supporting PnP in Linux, there are a majority of
> legacy ISA cards out there which do not support it anyway!
>
> See my point? Just because not every hardware out there supports a
> given standard doesn't make that standard necessarily useless.
>
> Just make the next version of ACPI better than the previous one (not
> necessarily a challenge) and everyone will embrace it.
>
>   
You get me wrong, I'm not against the proposal, so keep your breath.
I'm just saying that you get old waiting for BIOS vendors to export this 
info, even if it's in spec.

Regards,
Alex.
