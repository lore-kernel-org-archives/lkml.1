Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab0BAFMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 00:12:42 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:33307 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0BAFMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 00:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QeE9RaFKOh6Aza4ggqpsLhuqaO0KUSDDKmmsSYHaPhDKE597jsOrwa77kyOHukqay6
         jGZTP9pIgfxcoBEgbghIacGIl6NZ85ROIvCowQWi0neDlo4Yrt4oPtPl+BmngaxoIuBG
         a863jgBcZsBWcBusS0GIptqmcfCn6OYpOZfwM=
MIME-Version: 1.0
In-Reply-To: <1264783867.24455.11.camel@laptop>
References: <2674af741001282256l3058d356p752b49c024c47e1c@mail.gmail.com>
	 <1264783867.24455.11.camel@laptop>
Date: Mon, 1 Feb 2010 13:12:39 +0800
Message-ID: <2674af741001312112k517ed073w51e66a907438f301@mail.gmail.com>
Subject: Re: [RFC 0/2 PATCH] remove member rt_se from struct rt_rq
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, rusty <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 12:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-01-29 at 14:56 +0800, Yong Zhang wrote:
>> member rt_se of struct rt_rq is a duplicate of tg->rt_se[cpu].
>> So we can remove one of them. After checking CFS, I think
>> rt_rq->rt_se can be removed for some kinds of consistence.
>
> Looks good I think.

Hi Peter,

Seems nobody has objection on the two patches.
Can you pick them up?
Or should I resend the patchset again?

Thanks,
Yong
