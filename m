Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZJ2AAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZJ2AAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZJ2AAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:00:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:41183 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZJ2AAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Uzcl3oS+xnGMbGicQsOf8D1xZYQaNasooHpc08CfdBWaudBCtiPFl6KK8pV5DoB/nO
         y66+KdgcjsapXGmNIkvyPedHPllbHTiCodEV3BdiMv1BtunMK3lf73BnW/QQFvo3h1Ta
         SSEqcGnGWHlAzvKzUPsVcHNlowAXVgnlZNI8I=
MIME-Version: 1.0
In-Reply-To: <20091028222439.3e0be650@lxorguk.ukuu.org.uk>
References: <e86b7d350910281224i7e91a1ecp9f3d15d9c36f19cb@mail.gmail.com>
	 <20091028222439.3e0be650@lxorguk.ukuu.org.uk>
Date: Wed, 28 Oct 2009 19:00:10 -0500
Message-ID: <e86b7d350910281700x1383296i73cd1ee4694e9c8@mail.gmail.com>
Subject: Re: Hyperthreading on 4 core CPU DECREASES performance???
From: Igor Chudov <ichudov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 5:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This is Ubuntu Hardy, 2.6.24 kernel. I tried the same with 2.6.31,
>> with the same effect.

>> I would like to know how can I make the scheduler to prefer to spread
>> the tasks across physical cores as opposed to bundling two on one core
>> and leaving some cores idle.
>
> The scheduler will try and do balancing for packages and for HT. Make
> sure your distribution is built with the SCHED_SMT and SCHED_MC options
> enabled. Some of the non-enterprise distirbutions may well not have these
> enabled.

Yes, for the stock hardy -server and -generic kernel:

CONFIG_SCHED_MC=y
CONFIG_SCHED_SMT=y

>
> For hand laying out threads see: man pthread_setaffinity_np
>
> The win from HT depends a lot on the CPU and also the workload mix. In
> some workloads it will decrease performance.

OK, I think that I understand. Thanks.

So, what you are basically saying is that there is no option to
improve this behavior, right?

Thanks Alan.
