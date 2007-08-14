Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbXHNHJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbXHNHJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbXHNHJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:09:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:48635 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXHNHJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PiLFd0n8QsvKckspfmVDNrt7RHm3S4Vp1A28agtBKCmgqP11ySkMZAjWSCmz8YAehG2w9GBJe1sRYK3YJI5EBMgtSIPoiHsB/6k1zCwY340ocJVEiGDfQgJHO5vuUZCwyeYHAMAi8t5spFdmcRGFpJC9F27gbb8wIFVdDXgcvYQ=
Message-ID: <4bacf17f0708140008v657f5d5bqec17fcea67a6f69c@mail.gmail.com>
Date: Tue, 14 Aug 2007 09:08:59 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 0/3] [patch 0/3] genirq: Suppress resend of level interrupts
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Stable Team" <stable@kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       "Jarek Poplawski" <jarkao2@o2.pl>
In-Reply-To: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/12, Thomas Gleixner <tglx@linutronix.de>:
> The delayed irq disable functionality introduced a bug due to
> retriggering level type interrupts in case of the delayed disable. The
> resulting problem was discussed and debugged here:
> http://marc.info/?l=linux-kernel&m=118202978609968&w=2
>
> The resend of a level type interrupt is unnessecary and adds extra
> noise to the system. Level type interrupts are resent by hardware when
> they are still active at irq_enable(). The hard-/soft-ware resend is
> only useful for edge type interrupts.
>
> The following patch series addresses the problem and fixes an
> unnoticed mismerge which affects the same area as well.
>
>         tglx
>
Works fine for me (tested on 2.6.22.1). I uploaded 6 GB of data and my
network card didn't time out. (it usually did after 1-100 MB)
Is this the final version?

Regards,
Marcin Slusarz
