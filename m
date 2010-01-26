Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275Ab0AZLaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0AZLaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916Ab0AZLa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:30:29 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:40092 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0AZLa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:30:28 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 06:30:28 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BMy87E0M+9wZDc1V6eNjaZQfmITUHuqxsZZorDigPrebfrlxX9h96xa8UkAz4hI6qJ
         zLSHg/XuY8Mm2k7pjIxuv+K66vTVDRiknFjRjvQjQ/vV97T0qTHYxQrE+qHjXqwb4GHe
         h6GD3+FT4aVMXuaQvrlkVGo83EiTYBxhPPUo4=
MIME-Version: 1.0
In-Reply-To: <1264502668.4480.97.camel@utx.utx.cz>
References: <20100106071026.GD1382@ucw.cz>
	 <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
	 <20100107065230.GA1303@ucw.cz>
	 <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
	 <1264275669.9100.11.camel@utx.utx.cz>
	 <1264286611.11766.49.camel@utx.utx.cz>
	 <f17812d71001251958t377e158bxc64aac0cb426110b@mail.gmail.com>
	 <1264500824.4480.79.camel@utx.utx.cz>
	 <f17812d71001260220v5d03b0e1u1e3bc229827c37c8@mail.gmail.com>
	 <1264502668.4480.97.camel@utx.utx.cz>
Date: Tue, 26 Jan 2010 14:23:56 +0300
Message-ID: <bc64b4641001260323y496bf7cdv507085644fadb0fe@mail.gmail.com>
Subject: Re: gpio_keys and how PXA27x sets gpio_set_wake() (was Re: sharp 
	c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1)
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Andrew Morton <akpm@osdl.org>,
       thommycheck <thommycheck@gmail.com>, dtor <dtor@mail.ru>,
       arminlitzel <arminlitzel@web.de>,
       linux-input <linux-input@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>, Dirk <Dirk@opfer-online.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lenz <lenz@cs.wisc.edu>,
       rpurdie <rpurdie@rpsys.net>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, Cyril Hrubis <metan@ucw.cz>,
       zaurus-devel <zaurus-devel@www.linuxtogo.org>,
       omegamoon <omegamoon@gmail.com>, Vojtech Pavlik <vojtech@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2010/1/26 Stanislav Brabec <utx@penguin.cz>:
> Eric Miao wrote:
>> > The problem affects gpio_keys: It is a driver implementing "one key per
>> > gpio". It now handles On/Off and lid switches on Zaurus. Lid switches
>> > are on "normal" GPIOs, On/Off switch is wired to PKWR capable GPIO.
>> Ain't On/Off switch one of the matrix key? And so SPITZ_GPIO_KEY_INT
>> could be used to handle that?
>
> No. On/Off is connected directly to GPIO 95. Other keys use strobe/sense
> matrix keypad.
>
> SPITZ_GPIO_KEY_INT is a bit unspecific. I think it means: Charger was
> inserted or key was pressed or On/Off was pressed.

This seems to be true. At least they used the same design on tosa and other
zaurii.


-- 
With best wishes
Dmitry
