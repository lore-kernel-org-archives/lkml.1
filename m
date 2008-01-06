Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYAFWob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYAFWob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYAFWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:44:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:32337 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbYAFWoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Y+iLetLCaTlZCUvAdti0cjQUm78NKJOm4gHmWdjgOXvufyF7lN83z4BpyhJ9ewKbEnA2njE+0CNpzOyyd3WY9T/ettruejNKSe/x818XGnK4nUOam+V8cQ/ZqC173poMYG2aA8e63cW7aWevslukoBGjPKvQA1XCDUO5BQhNvEw=
Date: Mon, 7 Jan 2008 01:30:49 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 1/3] power_supply: add few more values and props
Message-ID: <20080106223049.GA13655@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080106122659.GA13106@doriath.ww600.siemens.net> <20080106140903.GA23333@zarina> <bc64b4640801061415m61c9fd9fr81d6ca03c2a5d626@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <bc64b4640801061415m61c9fd9fr81d6ca03c2a5d626@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 01:15:32AM +0300, Dmitry wrote:
[...]
> > > +     POWER_SUPPLY_ATTR(voltage_max),
> > > +     POWER_SUPPLY_ATTR(voltage_min),
> >
> > I'd suggest keep Documentation/power_supply_class.txt in sync
> > wrt new properties, to distinct their meanings and usage.
> >
> > I assume you're using these new properties for non-rechargeable
> > LiMn batteries. So, why new properties, aren't voltage_*_design
> > ones suits that purpose? If battery is non-rechargeable it is
> > having only design values, no?
> 
> No, I used it for the battery driver for Sharp Zaurus SL-6000 (tosa).
> It's connected via simple ADC so I can get only voltages. I don't know
> max_design value for the battery, but I have 'FULL' signal which I use
> to detect 'voltage_max' and use it for power estimations.

Ah, I see. In that case the value is empiric and voltage_max is
appropriate name indeed.

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
