Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZHAF5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZHAF5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 01:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZHAF5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 01:57:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:1806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZHAF5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 01:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s9nT07L/C392kopzbiBtKQzoOQQ71s0kK1q9kj4xVhcGAFan2E9PgaQX+CXVDwQrKQ
         J/6EmrW6/28gYcPEh6rkWoKsE3ipCeAMtMlWziWQnxB39rzilt3S9q91Lf6PjHYnaMoJ
         HYGM4Ic8bckIF57fr4HG3ZGzEZ7hC2zONKAkI=
MIME-Version: 1.0
In-Reply-To: <20090731214401.GC6335@sirena.org.uk>
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
	 <20090731172002.GA32578@rakim.wolfsonmicro.main>
	 <74d0deb30907311038w1b6cdd23iec3cfb2175fdedd0@mail.gmail.com>
	 <b90c0690907311332o958b7f4nd025aa7a8b273a88@mail.gmail.com>
	 <20090731214401.GC6335@sirena.org.uk>
Date: Sat, 1 Aug 2009 08:57:43 +0300
Message-ID: <b90c0690907312257u7a2677f0ne20d85ebaabc3935@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: Roger Quadros <quadros.roger@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 1, 2009 at 12:44 AM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jul 31, 2009 at 11:32:32PM +0300, Roger Quadros wrote:
>
>> Not having gpio_get_direction() in gpiolib is a limitation I think.
>> Can we just do the following for now ? (i.e. disable regulator by default)
>> Will there be any glitch? If yes, then how?
>
> If you're going to do this then like I say you should make the default
> state controllable by platform data.  If we unconditionally disable the
> regulator then if, for example, the regulator is controlling the display
> backlight and it's on when Linux get controls then the user will see the
> backlight blink off then on during startup.
>

OK I will add another bit for this in fixed_voltage_config.

Do we need to check whether CONFIG_GPIOLIB is available? or do we need
to explicitly
select it in Kconfig?
