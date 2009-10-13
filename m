Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbZJMTX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbZJMTX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934174AbZJMTXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:23:25 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42479 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934172AbZJMTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=rbsYOvIoj5Sx7TS8TTadVo1vdI9BL68phbcj/Wv6OkABs1O/25hvSi38Xp/S6ECoT0
         eO5+JVNYnxQWtTgj3pn7tAJvhdaACaUqhZUZObZor7mUz2GY3CDeRZped+PxyXlAv3TF
         eH8F89oyBRcUIe8mcTvRoQ37cHadOvMfHcUrg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 21:21:25 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00251-gd8c9210; KDE/4.3.1; x86_64; ; )
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910131927.24136.bzolnier@gmail.com> <200910132017.47748.IvDoorn@gmail.com>
In-Reply-To: <200910132017.47748.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200910132121.25743.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009 20:17:47 Ivo van Doorn wrote:
> On Tuesday 13 October 2009, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 13 October 2009 17:52:52 Ivo van Doorn wrote:
> > 
> > > I am going to merge rt2800pci soon as well and after that I'll send a patch
> > 
> > Great, I've been waiting for this for a long time.
> > 
> > > to remove all Ralink drivers from the staging tree.
> > 
> > Till new drivers obtain support for all hardware currently covered by
> > the unified staging drivers the latter shouldn't be removed as they
> > serve well their role as a temporary solution allowing real Linux users
> > to user their real hardware and as a reference material for developers
> > willing to work on adding the missing bits to new drivers.
> 
> The rt2800pci and rt2800usb drivers cover support for rt2860/rt2870/rt3070 devices,
> which are present as individual drivers in the staging tree. So far it only managed

There are no longer individual drivers.

Instead there is one shared source code and two device drivers:

- rt2860 covering RT2860 and RT3090 devices

- rt2870 covering RT2870 and RT3070 devices

In comparison rt2800usb currently lacks RT3070 support and rt2800pci's
RT3090 support is basic at best (not to mention that it didn't work for
RT2860 last time that I tried)..

> to confuse developers which wanted to work on Ralink support, so I haven't found

I bet they are truly grateful for being shown "the one and only way"..

> a benefit for having those drivers in the staging tree yet. But I am sure there are plenty

I was able to use my Eee 901 successfully with them for a last year and I'm
pretty sure that I'm not the only.  I understand my sin now -- I should have
had help in fixing the proper and clean code before using my hardware.. [*]

> of people who like the idea of having the original Ralink drivers inside the staging tree,
> so they can continue debugging that, so I won't talk about the staging downsides further.

Well, it would be much more productive if people concentrate on improving
_their_ projects and looking at downsides of _their_ code instead of going
around and looking at _obvious_ downsides of other people's projects.


[*] [Slightly off-topic but it shows the same problem with the approach]

I now also see why some distributions keep pushing some known non-working
things on their users (Fedora maintainers -- I'm talking to you), the best
example is PulseAudio -- it simply doesn't work reliably even on modern
hardware and/or using all scheduler tricks (it seems that making Linux into
full RT OS is a prerequisite for fixing latency issues observed)..

So yeah desktop/laptop/mobile users, do not worry -- you will get your sound
support back in few years time and if you're developer: don't dare to complain
you fussy saboteur!!
