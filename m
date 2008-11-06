Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYKFGnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYKFGnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYKFGm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:42:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:15525 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYKFGm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MtuMVHGKos6NSWmkK0XsU0RcmlKM26HKcyRXpdprvIklJe0dJNdHgVBkPVWKK2A39S
         Q4H9gSE8jj4i/g6jn/Nf6NZCMWtg6L9kayhc1ygGNpdU++KQv/ngEUGnBlgXvDbkkyNO
         hYYv+2qoeeuXid4z82cdENNyKGSl3UelL0n6w=
Message-ID: <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>
Date: Wed, 5 Nov 2008 22:42:57 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ben Hutchings" <bhutchings@solarflare.com>
In-Reply-To: <20081106062608.GC6384@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu>
X-Google-Sender-Auth: a30d936b9f67bb99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 10:26 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Impact: so NR_IRQS is bigger enough for system with lots of apic/pins
>>
>> Now: if IO_APIC is there, will have big NR_IRQS
>>
>> otherwise still use 224
>>
>> Signed-off-by: Yinghai <yinghai@kernel.org>
>
> applied to tip/x86/urgent, thanks Yinghai! Below are the final form of
> the two commit.
>
> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
> for good? Mind sending a patch for that too?

could remove CONFIG_PARAVIRT too.. Jeremy?

YH
