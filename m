Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZKIN3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZKIN3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZKIN3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:29:14 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42334 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbZKIN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:29:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hHtGWbGwCRhN579QCMi/Id7FMgUsbMmVVy7/h+K9IE6H7QuGzAc2P9udHnjcV2sQdb
         QxfeCt6xfAWIObxqenU7j4qtIx5tnVxs2JLTHefoQX5X0CBUz3yVb12Pw+sv0rF1eNPm
         t0U3oc8RkagGkfG1Srn7cRZa4ni8c/p7Y6Ek8=
MIME-Version: 1.0
In-Reply-To: <20091108143059.029abf8b@infradead.org>
References: <20090915054259.5282e5ba@infradead.org>
	 <4e5e476b0911040139h1f471627la4262a5fa66abab0@mail.gmail.com>
	 <20091108124035.23d53197@infradead.org>
	 <4e5e476b0911081359x32d7a6c4x61ee3af92dc0c8a1@mail.gmail.com>
	 <20091108143059.029abf8b@infradead.org>
Date: Mon, 9 Nov 2009 14:29:17 +0100
Message-ID: <4e5e476b0911090529g6ba93a9o91cfc1b15d7497d1@mail.gmail.com>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO performance
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       jens.axboe@oracle.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 11:30 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 8 Nov 2009 22:59:43 +0100
> I think we all agree that long term polling is bad ;-)
> (even though we use rep nop in the polling loop which is also a HT
> yield).
>
> There's just the very short sleeps (where short is "single digit usecs")
> where the rules are slightly different.
>
>> > this check is supposed to catch the known timer cases; those
>> > are rather accurate in prediction
>>
>> Unfortunately, I have seen polling residency times > 1ms, so it must
>> not be so accurate.
>
> well the question is... is this a measurement error or an error in
> when polling is chosen.
> We obviously need to fix it whatever it is, but... first need to chase
> down really which it is.

Any suggestion on how to check?
Clocksource is hpet, and I have CONFIG_SCHED_HRTICK=y, so the
granularity should not be a problem.

Corrado
