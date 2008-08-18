Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYHRGiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYHRGiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYHRGiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:38:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYHRGiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:38:16 -0400
Message-ID: <48A9180A.8020803@zytor.com>
Date: Sun, 17 Aug 2008 23:34:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, David Fries <david@fries.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
References: <20080818040340.GB17528@spacedout.fries.net>	<Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl>	<48A8FC21.9060908@zytor.com> <87skt2270c.fsf@basil.nowhere.org>
In-Reply-To: <87skt2270c.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>>
>> The other alternative is to probe for the CPUID instruction (via
>> EFLAGS.ID) -- CR4 is present if and only if CPUID exists.
> 
> Can be already checked for with boot_cpu_data.extended_cpuid_level.
> 

I believe you mean just plain cpuid_level (which is set to -1 if CPUID 
doesn't exist.)  extended_cpuid_level is only defined on x86-64, but all 
x86-64 CPUs have CR4.

	-hpa
