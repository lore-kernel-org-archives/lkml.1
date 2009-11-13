Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZKMTYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZKMTYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZKMTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:24:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:34924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801AbZKMTYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:24:48 -0500
Message-ID: <4AFDB238.5050903@kernel.org>
Date: Fri, 13 Nov 2009 11:23:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers	twice
References: <20091112204852.GB5728@lenovo> <4AFC98CF.5030408@kernel.org> <20091113175057.GA5695@lenovo> <4AFDABE3.2050006@kernel.org> <20091113190955.GC5695@lenovo> <4AFDB0AC.10302@kernel.org> <20091113192242.GD5695@lenovo>
In-Reply-To: <20091113192242.GD5695@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On Fri, Nov 13, 2009 at 11:17:00AM -0800, Yinghai Lu wrote:
>>>> Cyrill Gorcunov wrote:
>>>>> On Thu, Nov 12, 2009 at 03:22:55PM -0800, Yinghai Lu wrote:
>>>> 2. print out ...?
>>> Print out what? Not sure I understand you right. Perhaps you mean
>>> to check insert_resourse results?
> ...
>>   		apic_printk(APIC_VERBOSE,
>>  			    "mapped IOAPIC to %08lx (%08lx)\n",
>> -			    __fix_to_virt(idx), ioapic_phys);
>> +			    __fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
>>
>> YH
>>
> 
> Updated version below, thanks Yinghai! Looks good?

good to me.

YH

