Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXEFUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXEFUcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXEFUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:32:00 -0400
Received: from mail.z-net.ru ([89.113.80.10]:2912 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXEFUb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:31:59 -0400
Date: Mon, 7 May 2007 00:27:28 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig text confusion: Battery Class Support?
Message-ID: <20070506202728.GA9520@zarina>
Reply-To: cbou@mail.ru
References: <1178453212.7731.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1178453212.7731.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty,

On Sun, May 06, 2007 at 10:06:52PM +1000, Rusty Russell wrote:
> Hi all,
> 
> 	I know writing decent Kconfig help entries is an obscure art, but can
> we please try harder to make the help, y'know, helpful?  See below for
> my experience with 2.6.21-mm1.
> 
> 	How come the Kconfig help for EXTERNAL_POWER says "is mandatory for
> battery class support" and I still get prompted for "Battery class
> support" when I say N?
> 
> 	How come both these entries are of form "Foo (FOO)? -- Say Y here to
> enable foo."?   Shouldn't we assume the reader knows what Y means?
> 
> How about:
> 
>         Battery class support (BATTERY) [N/m/y/?] (NEW) ?     
>         
>         This allows battery monitoring by userspace via sysfs (if
>         available) and/or APM kernel interface (if selected below).  Say
>         Y or M if building a kernel for a laptop.
> 
> I don't even understand the CONFIG_EXTERNAL_POWER enough to comment on
> that one 8(
> 

Thank you for the message, Rusty. It's "fixed" already in battery2-2.6.git.

Yes, battery/external power separation was a complicated part of whole
battery stuff. Now, thanks to David Woodhouse, external power and
battery classes merged, and there is much simpler configuration now:

*
* Power supply class support
*
Power supply class support (POWER_SUPPLY) [N/m/y/?] (NEW) m
  Power supply debug (POWER_SUPPLY_DEBUG) [N/y/?] (NEW) y
  Generic PDA/phone power driver (PDA_POWER) [N/m/?] (NEW) m
  DS2760 battery driver (HP iPAQ & others) (BATTERY_DS2760) [N/m/?] (NEW) m
  One Laptop Per Child battery (BATTERY_OLPC) [N/m/?] (NEW) m

That's all you have to answer.

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
