Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYHZWEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYHZWEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYHZWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:04:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:21300 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbYHZWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HIfiMuh7rDYnjj0btNdW2jn7wFO64OlEVIlSfWpNJJVlD54TB/ZMUZ2x33G7dtSdaI
         qSxsyOpzIJkCVLUwBzPYa0bOwSd2Oh/GFMpmIk/AZwTRB0jco1UjqL6JXX50TZMfwSCM
         5pqDgYzmN5euT86YO40130FyZR9r2xuAkdSsQ=
Message-ID: <9929d2390808261504j6b1d4b2cl4786c15db3009f69@mail.gmail.com>
Date: Tue, 26 Aug 2008 15:04:19 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: e1000 horridness (was Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <48B4641A.1020806@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com>
	 <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
	 <200808261111.19205.rusty@rustcorp.com.au>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <48B45FA2.8040603@garzik.org>
	 <alpine.LFD.1.10.0808261257210.3363@nehalem.linux-foundation.org>
	 <48B4641A.1020806@intel.com>
X-Google-Sender-Auth: a6effd96de4fa7c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 1:14 PM, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> Linus Torvalds wrote:
>>
>> On Tue, 26 Aug 2008, Jeff Garzik wrote:
>>> e1000_check_options builds a struct (singular) on the stack, really... struct
>>> e1000_option is reasonably small.
>>
>> No it doesn't.
>>
>> Look a bit more closely.
>>
>> It builds a struct (singular) MANY MANY times. It also then builds up a
>> huge e1000_opt_list[] array, even though it is const and should be static
>> (and const).
>>
>> I know. I wrote a patch to FIX it.
>
> totally cool patch afaics - if I still maintained this driver I'd have this tested
> and merged right away :)
>
> I suppose Jeff Kirsher is already doing so right now

You suppose correctly.
.
>
> I suppose that he'll have to look at the other Intel ethernet drivers as well :)
>
> Jeff, please add my:
>
> Reveiewed-by: Auke Kok <auke-jan.h.kok@intel.com>
>

Will do.

-- 
Cheers,
Jeff
