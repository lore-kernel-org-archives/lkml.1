Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYAFXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYAFXNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbYAFXNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:13:12 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:30648 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbYAFXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:13:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FI0oF8tr+cq9RflU67Jg4GjdhsBuyB1nm7Pzkq1bxd9sfKvvdru56zmuJJEEJQm4Qn0pjFM+E6sL/5vkXHlX4FBalBkcwTbJ0fZZZd6/4NU0Nf69Qt8YLGP9KsR09+fOBY2IinbNAIdva9f0cRsNlXnnntfAyNBo7TlOjGD5wCw=
Message-ID: <bc64b4640801061513q4254fb2djf3b7203ab98773c6@mail.gmail.com>
Date: Mon, 7 Jan 2008 02:13:07 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com
Subject: Re: [PATCH 1/3] power_supply: add few more values and props
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
In-Reply-To: <20080106223049.GA13655@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080106122659.GA13106@doriath.ww600.siemens.net>
	 <20080106140903.GA23333@zarina>
	 <bc64b4640801061415m61c9fd9fr81d6ca03c2a5d626@mail.gmail.com>
	 <20080106223049.GA13655@zarina>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/1/7, Anton Vorontsov <cbouatmailru@gmail.com>:
> On Mon, Jan 07, 2008 at 01:15:32AM +0300, Dmitry wrote:
> [...]
> > > > +     POWER_SUPPLY_ATTR(voltage_max),
> > > > +     POWER_SUPPLY_ATTR(voltage_min),
> > >
> > > I'd suggest keep Documentation/power_supply_class.txt in sync
> > > wrt new properties, to distinct their meanings and usage.
> > >
> > > I assume you're using these new properties for non-rechargeable
> > > LiMn batteries. So, why new properties, aren't voltage_*_design
> > > ones suits that purpose? If battery is non-rechargeable it is
> > > having only design values, no?
> >
> > No, I used it for the battery driver for Sharp Zaurus SL-6000 (tosa).
> > It's connected via simple ADC so I can get only voltages. I don't know
> > max_design value for the battery, but I have 'FULL' signal which I use
> > to detect 'voltage_max' and use it for power estimations.
>
> Ah, I see. In that case the value is empiric and voltage_max is
> appropriate name indeed.

:) Documentation patch should be pretty trivial, could you please just
make it w/o another resent cycle?

>
> Thanks,
>
> --
> Anton Vorontsov
> email: cbou@mail.ru
> backup email: ya-cbou@yandex.ru
> irc://irc.freenode.net/bd2
>


-- 
With best wishes
Dmitry
