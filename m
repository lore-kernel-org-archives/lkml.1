Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYFJNvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYFJNvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYFJNuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:50:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:64971 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYFJNut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=U49S4/4sy525SO1ht/ye2KTd5GgJ6PrX8xiyt1rJsxmy5TFt7ElNfMzUQ2Zj38RwRr
         mTV8nyyGhqmx8HYJ2PQWH1MOS9eYo/0LSRVe8f4qNfLZ7NA9lOyUcoq2oOvhpt2vg+Bl
         9tXZCy216G+tP5g3AbIgF5/pGm7A8s97XLCXE=
Message-ID: <aec7e5c30806100650m41089e1p4b487837b6271471@mail.gmail.com>
Date: Tue, 10 Jun 2008 22:50:46 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20080610071032.GB22814@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080605090916.GA3198@local> <20080605112744.GB3198@local>
	 <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com>
	 <20080608205455.GA3191@local>
	 <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com>
	 <20080609084411.GA3223@local> <20080609090123.GA12080@linux-sh.org>
	 <20080609123406.GB27803@digi.com>
	 <aec7e5c30806092140s21cc8cbdtbaf69f864dd2bda7@mail.gmail.com>
	 <20080610071032.GB22814@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 4:10 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> I think you can implement the handler and irqcontrol functions static
> inline.  Then the need to statically compile uio goes away.  And if all
> uio_pdrv devices are registered in the same .c file you don't even have
> a (binary) size penalty.

Good idea, that's nice and clean.

>> Let me know what you want and I'll respin the patch. Thanks!
> ... I started describing in detail my suggestion, but actually it's
> easier to do the patch myself.  So here it comes.  Note it's not even
> compile tested, but you should be able to get my intentions.

Excellent! I wrote some code to export the VEU in sh7722 on top of
your patch and things work just fine. Slightly more structure members
to fill in with this approach, but that's fine. This less automatic
approach hopefully causes less confusion. =)

> From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Date: Tue, 10 Jun 2008 09:06:24 +0200
> Subject: [PATCH] UIO: wip
>
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Acked-by: Magnus Damm <damm@igel.co.jp>

Thanks for your help!

/ magnus
