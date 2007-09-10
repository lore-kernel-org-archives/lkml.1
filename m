Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbXIJO2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbXIJO2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbXIJO23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:28:29 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:27351 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbXIJO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ruhr0n0XfXbG3vE0jtO5ElK7XKM/6I0DcSVywye9AHrYnaIfX7AEMLUdGTmxwr3+0HU95QkJntpb3OnFc/cSzj1aupr46j5eYjHROImifdrMFxXiQNp4qR5nmgWAV1CBPdW5eHZcQdMozKzHfweT4m8MAvdKEIw7KXX5GanGpuQ=
Message-ID: <8b67d60709100728o699a7fefkc1cb610939fa12d4@mail.gmail.com>
Date: Mon, 10 Sep 2007 15:28:27 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH 2/3] Maple bus support for the Sega Dreamcast - keyboard support
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200709092350.47602.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60709091001l3cd6adf6m2dab8e815f47435d@mail.gmail.com>
	 <20070909214438.79959ace@laptopd505.fenrus.org>
	 <8b67d60709091357k2bc0c673kef5716a97f07bd3a@mail.gmail.com>
	 <200709092350.47602.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2007, Dmitry Torokhov <dtor@insightbb.com> wrote:
> Hi Adrian,
>

Thanks for the comments - will get on with this but....


> > +     for (i = 0; i < NR_SCANCODES; i++)
> > +             kbd->keycode[i] = dc_kbd_keycode[i];
>
> memcpy?
>

I see that other drivers use memcpy - and will happily convert over -
but, out of interest, is there a reasopn why it is superior?

>
> maple_device appears to be fully integrated in sysfs, please add:
>        kbd->dev->dev.parent = &dev->dev;
>

The bus code already correctly ids the parent device (the above code
would appear to assign the device as the device's parent
incidentally). Is it wrong to make that assignment in the central bus
code as opposed to the driver?

Thanks

Adrian
