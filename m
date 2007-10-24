Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbXJXWmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbXJXWmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXJXWm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:42:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:61966 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbXJXWm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Laz1CZwATFPy4FY9wtGUU+SscYrqFs9ElM0GYlmC9Gb5NDzsZj8LzqNsqY2ubN9wNV/NG6854VBWudIxrkQJx/+F7sOlmJZitjyNaGwPylkWuEekxRXSQW/hteSP+WfjTmB6NL0QN6bqbfaIKZa3rM1p/31RahXfeOTJJaxyD5I=
Message-ID: <b70f2f960710241542t6c3501a5k3d44e80906ce8b97@mail.gmail.com>
Date: Thu, 25 Oct 2007 02:42:26 +0400
From: "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: x86_64 and AMD with C1E
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <471FBC09.8050201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001101532.025d652f@localhost> <4718DDB7.7070707@redhat.com>
	 <b70f2f960710241426y40d25647v3f25b275fad5ce76@mail.gmail.com>
	 <471FBC09.8050201@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/25, Chuck Ebbert <cebbert@redhat.com>:
> On 10/24/2007 05:26 PM, Mikhail Kshevetskiy wrote:
> >>>
> >>> I fill something wrong here.
> >>> Is it possible to reduce the amount of timer interrupts?
> >>> Is it possible to force enable C1,C2 and C3 states when c1e disabled?
> >>>
> >> How are you disabling C1E?
> >>
> >>
> > dirty hack, i just follow the FreeBSD way and clear C1e bit in lapic
> > initialization code. I make it for test purpose only, so i do not produce a
> > patch.
> >
>
> Why does disabling C1E disable C1, C2 and C3?

i don't know. Normally (C1E enabled) i have C1 power state only. When
I disable C1E, i have no any power state (AMD spec say i should have
C1 and C2; C3 is optional)

> Thomas, in the case of the machines where C1E is disabled on CPU 0 but
> enabled on CPU 1, could we just disable it? Maybe it's a BIOS bug and the
> vendor just forgot to disable CPU 1...
