Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYKFHH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYKFHH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYKFHHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:07:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYKFHHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:07:15 -0500
Message-ID: <491296B2.6090700@zytor.com>
Date: Wed, 05 Nov 2008 23:03:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu>	 <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>	 <4912943C.2090801@zytor.com> <86802c440811052300y279bd289t74b437a2053b97d1@mail.gmail.com>
In-Reply-To: <86802c440811052300y279bd289t74b437a2053b97d1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Nov 5, 2008 at 10:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>>> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
>>>> for good? Mind sending a patch for that too?
>>> could remove CONFIG_PARAVIRT too.. Jeremy?
>>>
>> This seems like a bad idea, especially for the embedded guys.
> 
> make one CONFIG_NR_IRQS for them before working out one dyna_array is
> get merged?
> 

Ah, sorry... I missed the context and thought you meant removing 
CONFIG_PARAVIRT in general.

	-hpa
