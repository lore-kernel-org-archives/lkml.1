Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbXIDDml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbXIDDml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 23:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbXIDDme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 23:42:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8550 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbXIDDmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 23:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jh0XR5v1ck1qOX5X2N9sJRgluPsIEXGVuMPtGNzQBRlll/wP1htKEqiU/x/MSiXS5iRpLlDQFI9mcqmgjjhy1S3sAQXlSt2dPAJHUZ/OrCOWF3tZuuA3Nw/Hcm350158bqkeU1qab9XSD85wO47xgWCVrJ1DIrYELwxPypwoRnU=
Message-ID: <2ff216280709032042t4a507feci8d5759526971ae7b@mail.gmail.com>
Date: Tue, 4 Sep 2007 09:12:32 +0530
From: "Abhijit Bhopatkar" <bain@devslashzero.com>
To: "Ivan N. Zlatev" <contact@i-nz.net>
Subject: Re: [PATCH] [ALSA] Added new pin config for first gen macbook.
Cc: "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <3db1ec7f0709030506j5fe6dbc3w6c7ae8daa94c3323@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2ff216280709030325r626d98b3h2c5a48e90470610b@mail.gmail.com>
	 <s5hr6lgdoiv.wl%tiwai@suse.de>
	 <3db1ec7f0709030407y2cb9fc8ew52160ca28b2592d2@mail.gmail.com>
	 <3db1ec7f0709030506j5fe6dbc3w6c7ae8daa94c3323@mail.gmail.com>
X-Google-Sender-Auth: 33a443c4b9260377
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Ivan N. Zlatev <contact@i-nz.net> wrote:
> On 9/3/07, Ivan N. Zlatev <contact@i-nz.net> wrote:
> > On 9/3/07, Takashi Iwai <tiwai@suse.de> wrote:
> > > At Mon, 3 Sep 2007 15:55:18 +0530,
> > > Abhijit Bhopatkar wrote:
> > > >
> > > > commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1 changed all
> > > > pin configs for intel macs, but it breaks sound on
> > > > Macbook first
> > >
> > > Please elaborate how does it break.  "it breaks sound" is too
> > > ambigious like the most popular bug reports "sound doesn't work" :)

Apologies for the terse report,

On my macbook with latest kernels

1. Alsamixer is showing only three controlls in total,
    Master PCM and Digital.
2. There is absolutely no output sound what so ever.
3. There is no capture sound being captured either.

Reverting back the pin config to the one in previous kernels is
working (although not perfect e.g. to enable input sound we need to
toggle the capture device to mic and linein atlease once, no idea
whats the deal with that)

I am willing to do whatever test you people want, though I do not know
where to look for more info at this point. So please feel free direct
me to arrive at a better soultion or better info.

Thanks

Abhijit

PS:
lspci -v shows

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
        Subsystem: Unknown device 8384:7680
        Flags: us master, fast devsel, latency 0, IRQ 21
        Memory at 90440000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
        Capabilities: [70] Express Unknown type IRQ 0

Let me know if you need output dump of other stuff.
