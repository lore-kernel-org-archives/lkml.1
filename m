Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYHVA1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYHVA1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYHVA1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:27:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:43255 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbYHVA1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IJ8AwKC3+Ws5zP1DhHWrvgL2Z5CV1FPDmfCpViqbx0oP+scDBwh4TiKBjux8mizGTZ
         2J01QeWfJnGmhjxXOiFLeGCgi6tT2oSBRBkLQ7t3wA6BqO0EUW4xE+d5S0gYLDQsFeWD
         WwuH429xTwfrzGWGiaasTMvQYjfqakGkRgwGU=
Message-ID: <86802c440808211727n7656b634t8655b125f0e3cfc6@mail.gmail.com>
Date: Thu, 21 Aug 2008 17:27:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alex Nixon" <alex.nixon@citrix.com>
In-Reply-To: <48AE022F.6030100@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>
	 <48ADFB33.8010204@goop.org>
	 <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com>
	 <48ADFFD2.7030309@goop.org>
	 <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com>
	 <48AE022F.6030100@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 5:02 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>> like system vectors with smp-ipi etc?
>>
>
> More or less.  Xen currently uses 6 per-cpu event channels, and it maps
> each to its own irq.  My plan is to allocate just 6 irqs, map 6 vectors
> to them, and bind each event channel to a vector/cpu pair.  If nothing
> else, it will make /proc/interrupts somewhat sane again.
>
>
>>> Also, implementing probe_nr_irqs() in a more generic (rather than
>>> io_apic-specific) way.  Using some interface that queries each irq chip
>>> for how many irqs it supports, or something.
>>>
>>
>> hope we can kill nr_irqs/NR_IRQS
>>
>
> When irqs are truely dynamically allocated?
>
need more test with sparse_irq

YH
