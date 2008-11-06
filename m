Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYKFHAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYKFHAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYKFHAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:00:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:17094 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYKFHAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:00:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CdY98402/2P4OJrT11yvMAfQcd8T2wThGpd4oJhrvmNwvcvo9r3HOHqD7Fz8jebobF
         2FCCUzbJCsjRxaDb0gq0RJCIT6XBChF+QQOdBR+QGrnCI7FxFbZ+myUQb+8joVBsZu9P
         1BbLindUWbI98RoeNc16pa4UQ7WubETsCNr/Q=
Message-ID: <86802c440811052300y279bd289t74b437a2053b97d1@mail.gmail.com>
Date: Wed, 5 Nov 2008 23:00:01 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ben Hutchings" <bhutchings@solarflare.com>
In-Reply-To: <4912943C.2090801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu>
	 <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>
	 <4912943C.2090801@zytor.com>
X-Google-Sender-Auth: 4a5fcb2d6bfba4ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 10:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>>
>>> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
>>> for good? Mind sending a patch for that too?
>>
>> could remove CONFIG_PARAVIRT too.. Jeremy?
>>
>
> This seems like a bad idea, especially for the embedded guys.

make one CONFIG_NR_IRQS for them before working out one dyna_array is
get merged?

YH
