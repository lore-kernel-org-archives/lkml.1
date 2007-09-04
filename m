Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXIDOSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXIDOSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbXIDOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:18:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:8216 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbXIDOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PbRpVy+ad8GHpfN+wFiBRbTWHZF6LADN2ZWXao48Ot1kzjkWscgG4pNJCyP6Tg3cb72GVia4e7o5/ItwvBtuZWQ/z9NOz4WHV3SgHb+D+wT9yc4cpPF08obB8RAqzc3AyyVmsKLmLyjOv1ZHIuuC19SIt6tf2ueHmVuXyUqrJuE=
Message-ID: <2ff216280709040718y4b8e1fa7x1f51cc68f1d18de9@mail.gmail.com>
Date: Tue, 4 Sep 2007 19:48:23 +0530
From: "Abhijit Bhopatkar" <bain@devslashzero.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH] [ALSA] Added new pin config for first gen macbook.
Cc: "Ivan N. Zlatev" <contact@i-nz.net>, "Jaroslav Kysela" <perex@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5hmyw28u8a.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2ff216280709030325r626d98b3h2c5a48e90470610b@mail.gmail.com>
	 <s5hr6lgdoiv.wl%tiwai@suse.de>
	 <3db1ec7f0709030407y2cb9fc8ew52160ca28b2592d2@mail.gmail.com>
	 <3db1ec7f0709030506j5fe6dbc3w6c7ae8daa94c3323@mail.gmail.com>
	 <2ff216280709032042t4a507feci8d5759526971ae7b@mail.gmail.com>
	 <s5hmyw28u8a.wl%tiwai@suse.de>
X-Google-Sender-Auth: 026d976146a597b4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 4 Sep 2007 09:12:32 +0530,
> Abhijit Bhopatkar wrote:
> >
> > On 9/3/07, Ivan N. Zlatev <contact@i-nz.net> wrote:
> > > On 9/3/07, Ivan N. Zlatev <contact@i-nz.net> wrote:
> > > > On 9/3/07, Takashi Iwai <tiwai@suse.de> wrote:
> > > > > At Mon, 3 Sep 2007 15:55:18 +0530,

> OK, these are real problems.
>
> > I am willing to do whatever test you people want, though I do not know
> Just to be sure, doesn't none of intel-mac-[1-5] model match with your
> machine?  If so, putting the pin-config back is the straightforward
> solution indeed.
>
> Anyway, it'd be helpful if someone else can check the same MacBook
> (1st generation, not Pro?) whether the problem is reproducible.

To be precise its Macbook 1st Generation non pro.  with subsystem id 0x106b0a00

Well a friend of mine has the same model and i tried things out on his machine.
to my surprise :(, the original 2.6.23-rc5 is working fine on his machine.

So on my machine we booted to windows and tested things out. The sound
on my machine doesn't work in windows either, although its working in
OSX.

So sorry for all the noise its most likely a hardware problem after all.
Although i am baffled as to why old pin config works on this
particular broken hardware.

I hope i didn't bug you too much, i appreciate your quick responses.
Abhijit
