Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZKFGvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZKFGvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 01:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZKFGva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 01:51:30 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51520 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZKFGva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 01:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=byN3SUklUaVJiUDLUVeOUj3oz/0/eW0II0ctFgV3R5q482RyZqOIot2xOOaWyp1Sug
         0x+iNvCi4qRwti7omkL0kxafnndhyHIfIfuxWgO4RV00WB6DuI163SOfo9NZl+7eDR6X
         NWNrUpY3wh7pKDaDuNMtv67hlqHLa0Fvg7hbc=
MIME-Version: 1.0
In-Reply-To: <4AF3BD43.1000201@kernel.org>
References: <2674af740911052200m141e71d5v37d621d23771aa91@mail.gmail.com>
	 <4AF3BD43.1000201@kernel.org>
Date: Fri, 6 Nov 2009 14:51:35 +0800
Message-ID: <2674af740911052251w258821d2ub7e46a4c639371ef@mail.gmail.com>
Subject: Re: [PATCH] irq: remove __weak early_irq_init()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 2:08 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Yong Zhang wrote:
>>>From 86a53664e3f503fe06b166fb248ed64a77212b3d Mon Sep 17 00:00:00 2001
>> From: Yong Zhang <yong.zhang0@gmail.com>
>> Date: Fri, 6 Nov 2009 13:53:30 +0800
>> Subject: [PATCH] irq: remove __weak early_irq_init()
>>
>> impact: cleanup
>>
>> Since commit 12026ea16a618b289fcf457661aed24f57323a20
>> early_irq_init() is always defined in kernel/irq/handle.c
>> So remove the weak definition.
>
> some arches that do not have GENERIC_HARDIRQS defined need that.
>

Thanks for your point. I just notice kernel/irq is determined by
GENERIC_HARDIRQS.

-Yong

> YH
>
