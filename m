Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYFJEkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYFJEkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYFJEko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:40:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:32991 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYFJEkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O+5OJ7Xq5u12IDVJ/6x7G24mHEJyOegmMU6OjL1vR3z7aVrKIxs4yopEwI/JUZwY6h
         qPDEEuvCk2whaqZY+rsXeu9Zi1SaPS6L6jepp2HONPzRe+2a3gMqXClesrN+3RiDVlxv
         7VA6Kuxm2EaDNVgAMEgDrEz/eJzD9qHg27gNc=
Message-ID: <aec7e5c30806092140s21cc8cbdtbaf69f864dd2bda7@mail.gmail.com>
Date: Tue, 10 Jun 2008 13:40:42 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
       tglx@linutronix.de
In-Reply-To: <20080609123406.GB27803@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080604101144.GA3207@local> <20080605090916.GA3198@local>
	 <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com>
	 <20080605112744.GB3198@local>
	 <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com>
	 <20080608205455.GA3191@local>
	 <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com>
	 <20080609084411.GA3223@local> <20080609090123.GA12080@linux-sh.org>
	 <20080609123406.GB27803@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Thanks for your help.

On Mon, Jun 9, 2008 at 9:34 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> Paul Mundt wrote:
>>                                   [...] the constructive way forward
>> seems to be to follow Uwe's suggestions and respin the patch.
> Just to let you know: I'm willing to look on a new version.  And I like
> "User IRQ Mode".

Sure, let's go with that name then.

But shall we really go down the path with separate exported functions?
I think we discussed that earlier. Why I'm asking is that this adds
extra complexity - function prototypes in header files,
EXPORT_SYMBOL() stuff and more lines of code needed for each driver
instance.

Isn't it enough to add a kconfig option for CONFIG_UIO_PDRV_USER_IRQ
which depends on CONFIG_SUPERH (if we really want that) and wrap the
code in CONFIG_UIO_PDRV_USER_IRQ?

Let me know what you want and I'll respin the patch. Thanks!

/ magnus
