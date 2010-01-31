Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821Ab0AaSoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0AaSoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 13:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039Ab0AaSoY
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 13:44:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46076 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0AaSoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 13:44:23 -0500
Message-ID: <4B65CF5B.3000804@zytor.com>
Date: Sun, 31 Jan 2010 10:43:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: enlightenment for ticket spinlocks
References: <4B65C5BE02000078000584B5@vpn.id2.novell.com>
In-Reply-To: <4B65C5BE02000078000584B5@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2010 10:02 AM, Jan Beulich wrote:
>>>> "H. Peter Anvin"  01/31/10 2:42 AM >>>
>> + * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
>> + *      of a Xen host.
>> + */
>> +#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
>> +#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
>> +#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
>>
>> I hope you know this spells "MMXenVMMXenV".  The ordering is ecx-edx-ebx
>> (register numbers 1, 2, 3).
> 
> According to the documentation I have, the ordering is EBX-EDX-ECX,
> so indeed the spelling would seem broken, but since this is an interface
> header taken directly from Xen, it's got to be (and it works) that way.
> Odd.
> 

It's probably a bug that's now cast in stone.  That happends.  I just
had to be picky.  (And yes, it's ebx-edx-ecx; see my second email.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

