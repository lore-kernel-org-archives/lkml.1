Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZKCWBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZKCWBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZKCWBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:01:32 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52767 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbZKCWBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jWSFwDXEmwnZb/trmeg3b33sY/VId47YCxjyN6rbsvEO90/o6pSzxZvYY2GCrb+JSk
         lyV8xg4T3TIisZgdtHPusP1sygZAtNT/b5F8zTH/wHoZ61B1moN4a0dO1uDleOLMDgpN
         cg/Ws9NnFTJLNxJb83xJnVcBoAoYH0WDCU6aU=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
Date: Tue, 3 Nov 2009 23:01:32 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
References: <200911031951.05235.bzolnier@gmail.com> <200911032200.04516.IvDoorn@gmail.com> <200911032244.11946.bzolnier@gmail.com>
In-Reply-To: <200911032244.11946.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911032301.32907.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The following patch series (against wireless-next) addresses issues raised
> > > during code review and subsequently rejected by rt2x00/wireless/networking
> > > maintainers.
> > 
> > Really stop reading only the half of emails, try reading it entirely (or at least don't
> > stop at the second word in a sentence). It really starts the bug me to repeat
> > myself over and over again because you refuse to read.
> > 
> > Your comments during code review were ACCEPTED with the only remark that
> > it shouldn't be done right here and now.
> 
> Please stop this bullshit.  We have some standards for the upstream code
> and by being maintainer you have to live up to this standards and make sure
> that they are respected instead of watering them down yourself..
> 
> You were not interested even in fixing the headers duplication (it turned
> out debugging scripts needed only 25 lines of code to be able to work with
> fixed headers -- 25 LOC in bash scripts used only for debugging instead
> of 1800 LOC of kernel code).

Yeah I know that. But like I said, I still needed to get around to do that,
and I am very happy you were interested in fixing it.

> Also: I've mostly heard that I can fix the code myself.  Which I did.

And thats good.

> > > The rewrite was quite conservative and there is still a room for improvement
> > > but it should serve as a good starting base for all future work on rt2800
> > > drivers, and there is a lot to do there (both drivers are still practically
> > > non-functional).
> > 
> > Hence the reason I can use my rt2800usb device as long as I don't connect to
> > a 11n AP. But since everybody in the world has 11n devices, the rt2800usb device
> > is not capable of doing anything...
> 
> I use 11bg AP but mine rt2800usb device is RT3070 (which is quite popular
> nowadays) and it simply doesn't even work with rt2800usb currently.

Mine devices are plain rt2870 chips.

> > > Comments and patches are welcomed.
> > > 
> > > 
> > > The following changes since commit fa867e7355a1bdcd9bf7d55ebe9296f5b9c4028a:
> > >   Juuso Oikarinen (1):
> > >         wl1271: Generalize command response reading
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git rt2800
> > > 
> > > Bartlomiej Zolnierkiewicz (40):
> > >       rt2800usb: fix rt2800usb_rfcsr_read()
> > >       rt2800pci: fix crypto in TX frame
> > >       rt2800pci: fix comment about register access
> > >       rt2800pci: fix comment about IV/EIV fields
> > >       rt2x00: fix rt2x00usb_register_read() comment
> > >       rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
> > [.. snip..]
> > >       rt2800usb: fix comments in rt2800usb.h
> > >       rt2800usb: add RXINFO_DESC_SIZE definition
> > [..snip..]
> > >       rt2800: fix comments in rt2800.h
> > [..snip..]
> > >       rt2x00: remove needless ifdefs from rt2x00leds.h
> > 
> > These 10 patches look sane enough. Please send them as patch series
> > to linux-wireless.
> 
> I'll re-post later whole patch series to linux-wireless to ease the review.

Make them 2 series, the above can be the real [PATCH] (which I will ack directly),
and the others can be RFC's which can be reviewed/discussed further.

> > >       rt2x00: add support for different chipset interfaces
> > 
> > Not needed, you can determine exactly what chipset you have
> > by looking at the other fields. So extending the structure to
> > repeat the same information isn't needed.
> 
> It is a better to have a single field always indicating this since:
> - combining information from other fields is complex and error-prone
> - the situation may change in the future
> 
> However I would love to be proven wrong with the patch.

Well something that looks like this (as function in rt2800lib.h)

static inline is_rt2800pci(__chip)
{
	return
		(__chip->rt & 0xFF00) == 0x0600 ||
		(__chip->rt & 0xFF00) == 0x0700 ||
		__chip->rt == 0x2880 ||
		__chip->rt == RT3052;
}

You might even go a bit shorter by checking for USB instead:

static inline is_rt2800usb(__chip)
{
	return __chip->rt == RT2870
}

In rt2800lib you already know __chip->rt is part of
the rt2800 family, the is_rt2800usb() (or whatever name
you are going to give that function) is sufficient to know
if you are using PCI or USB.

And when that is not good enough, then please change the
field to only indicate PCI or USB. That way the field could be
used for other things in the future.

> > >       MAINTAINERS: add rt2800 entry
> > 
> > I see you decided to take over the maintainership?
> 
> This is my kernel tree after all. :)

Fine, but please keep this patch in your tree then. ;)

> > Doesn't that need the current maintainer to move away, or was this part
> > of the "going over other peoples head" plan?
> 
> I just do what is the best to get working drivers in the foreseeable future.

Thanks,

Ivo
