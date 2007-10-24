Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXJXVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXJXVlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbXJXVlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:41:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646AbXJXVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:41:39 -0400
Message-ID: <471FBC09.8050201@redhat.com>
Date: Wed, 24 Oct 2007 17:41:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86_64 and AMD with C1E
References: <20071001101532.025d652f@localhost> <4718DDB7.7070707@redhat.com> <b70f2f960710241426y40d25647v3f25b275fad5ce76@mail.gmail.com>
In-Reply-To: <b70f2f960710241426y40d25647v3f25b275fad5ce76@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2007 05:26 PM, Mikhail Kshevetskiy wrote:
>>>
>>> I fill something wrong here.
>>> Is it possible to reduce the amount of timer interrupts?
>>> Is it possible to force enable C1,C2 and C3 states when c1e disabled?
>>>
>> How are you disabling C1E?
>>
>>
> dirty hack, i just follow the FreeBSD way and clear C1e bit in lapic
> initialization code. I make it for test purpose only, so i do not produce a
> patch.
> 

Why does disabling C1E disable C1, C2 and C3?

Thomas, in the case of the machines where C1E is disabled on CPU 0 but
enabled on CPU 1, could we just disable it? Maybe it's a BIOS bug and the
vendor just forgot to disable CPU 1...
