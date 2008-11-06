Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbYKFHKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbYKFHKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYKFHK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:10:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:15440 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYKFHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LNoL/T+E3fDotvPgw9BEgdJvFcmXU2O3oRwqzFMRarSwvkVBBDTjPXO6TMPPR+fXdt
         kiP741LUqb3aEPSV4XDPUAtdPYdWmNUM2vcTaLf//DxP8znr2BVq4ppe8gTsLcGY7wB0
         daezy5+DjQXDx1JAZhT+iG6Y6kAI9o2QcFVu0=
Message-ID: <86802c440811052310o1cd9d75bma489d9ab66ed514a@mail.gmail.com>
Date: Wed, 5 Nov 2008 23:10:26 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ben Hutchings" <bhutchings@solarflare.com>
In-Reply-To: <491296B2.6090700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu>
	 <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>
	 <4912943C.2090801@zytor.com>
	 <86802c440811052300y279bd289t74b437a2053b97d1@mail.gmail.com>
	 <491296B2.6090700@zytor.com>
X-Google-Sender-Auth: c0b3afe6b3090e2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 11:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> On Wed, Nov 5, 2008 at 10:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> Yinghai Lu wrote:
>>>>>
>>>>> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
>>>>> for good? Mind sending a patch for that too?
>>>>
>>>> could remove CONFIG_PARAVIRT too.. Jeremy?
>>>>
>>> This seems like a bad idea, especially for the embedded guys.
>>
>> make one CONFIG_NR_IRQS for them before working out one dyna_array is
>> get merged?
>>
>
> Ah, sorry... I missed the context and thought you meant removing
> CONFIG_PARAVIRT in general.

I mean make NR_IRQS bigger like IO_APIC is set when CONFIG_PARAVIRT is set.

YH
