Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0BAH4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:56:41 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:26446 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0BAH4k convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Mon, 1 Feb 2010 02:56:40 -0500
Message-Id: <4B669742020000780002CEEB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 01 Feb 2010 07:56:34 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <jeremy@goop.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] x86: enlightenment for ticket spinlocks
References: <4B65C5BE02000078000584B5@vpn.id2.novell.com>
 <4B65CF5B.3000804@zytor.com>
In-Reply-To: <4B65CF5B.3000804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 31.01.10 19:43 >>>
>On 01/31/2010 10:02 AM, Jan Beulich wrote:
>>>>> "H. Peter Anvin"  01/31/10 2:42 AM >>>
>>> + * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
>>> + *      of a Xen host.
>>> + */
>>> +#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
>>> +#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
>>> +#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
>>>
>>> I hope you know this spells "MMXenVMMXenV".  The ordering is ecx-edx-ebx
>>> (register numbers 1, 2, 3).
>> 
>> According to the documentation I have, the ordering is EBX-EDX-ECX,
>> so indeed the spelling would seem broken, but since this is an interface
>> header taken directly from Xen, it's got to be (and it works) that way.
>> Odd.
>> 
>
>It's probably a bug that's now cast in stone.  That happends.  I just
>had to be picky.  (And yes, it's ebx-edx-ecx; see my second email.)

The "good" thing is that this is not on leaf 0, but on leaf 0x4000??00,
i.e. "normal" code would never display this garbled string.

Jan

