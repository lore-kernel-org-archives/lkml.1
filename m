Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821Ab0AZJRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0AZJRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569Ab0AZJRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:17:50 -0500
Received: from smtp-out.google.com ([216.239.33.17]:17770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0AZJRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:17:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=MDHv/EQuvKGeJ8hTl/b0EUcnNQRX6WkZb7HNwsf5A25M0TqWwpmDqJKtib+FzMN6L
	HFRpE5KFZsSGrXehu0Q0A==
MIME-Version: 1.0
In-Reply-To: <1264442381.4283.1944.camel@laptop>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
	 <7c86c4471001250912l47aa53dfw2c056e3a4733271e@mail.gmail.com>
	 <1264440342.4283.1936.camel@laptop>
	 <7c86c4471001250948t2c1b06ebx2e70f30f45c81aad@mail.gmail.com>
	 <1264442381.4283.1944.camel@laptop>
Date: Tue, 26 Jan 2010 10:17:45 +0100
Message-ID: <bd4cb8901001260117wf128e13kf188a4b0267fc153@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v6 
	incremental)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 6:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-01-25 at 18:48 +0100, stephane eranian wrote:
>> So we have to modify hw_perf_enable() to first disable all events
>> which are moving,
>> then reprogram them. I suspect it may be possible to optimize this if
>> we detect that
>> those events had already been stopped individually (as opposed to
>> perf_disable()), i.e.,
>> already had their counts saved.
>
> Right, I see no fundamentally impossible things at all, we just need to
> be careful here.
>
> Anyway, I poked at the stack I've got now and it seems to hold up when I
> poke at it with various combinations of constraint events, so I'll push
> that off to Ingo and then we can go from there.
>
> Thanks for working on this!

Ok, so I think the best way to proceed here is to first wait until all of this
is checked in. Then I'll see what is missing based on what we discussed
here.
