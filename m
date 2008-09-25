Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbYIYRDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbYIYRDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYIYRDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:03:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:27586 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYIYRDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Z+ywknQyBYQvKo9fTonoafTgkoEYRrL6o/ua7wQRRfIgQ99cFOtybWTtnSX0kVKjqO
         xKXHJmu9hBFLUNQEvly5n1/v4pOOqhMp7mlkktXeDCz7E/rCxeFx23Nc9z3PEvWvuS45
         ZhVlHdjuApAdP9MxuA3MTRoOnYDmn06pI1G1M=
Message-ID: <86802c440809251003hb71a6c4vcf51ff018f27f56c@mail.gmail.com>
Date: Thu, 25 Sep 2008 10:03:09 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Len Brown" <lenb@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080925091211.GA4922@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080925084212.GE4519@elte.hu> <20080925091211.GA4922@elte.hu>
X-Google-Sender-Auth: 1290cebb09a64ef5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 2:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> > v2: fix hpet compiling
>
> still bad:
>
> arch/x86/kernel/hpet.c: In function 'hpet_late_init':
> arch/x86/kernel/hpet.c:828: error: 'dev' undeclared (first use in this function)
> arch/x86/kernel/hpet.c:828: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/hpet.c:828: error: for each function it appears in.)
>
> we've got some changes in this area (per cpu hpet).

will check it.

YH
