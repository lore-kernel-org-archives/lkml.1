Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbZEPEUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbZEPEUG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 00:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZEPETy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 00:19:54 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:52481 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZEPETx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 00:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TyIl+znBIQzasQEhrl4aGuFei2h2y/qGzwEfGbbM9O1em9Lg5XinRXKh3q/95PzYmf
         QdZreNWh4NmnPC6o1IK8EDR0YT1e63ATxiFLqXNdJe6iORkgF98BZiJF11wBkwT9cfon
         2NR4BqIIRsZj4TgZQhw2zz4H28aYs4aghSJiI=
MIME-Version: 1.0
In-Reply-To: <20090515200235.GA11829@nokia.com>
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> 
	<45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com> 
	<20090515200235.GA11829@nokia.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Sat, 16 May 2009 05:19:33 +0100
Message-ID: <45cc95260905152119l6d4e76d1k6a11af2b177219ef@mail.gmail.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
To: felipe.balbi@nokia.com
Cc: Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Jonathan Cameron <jic23@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 9:02 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:

> Yeah, let's try to define the best way to expose accelerometers with
> linux kernel and avoid a sysfs hell. Better sooner than later.

isn't the best way to add a thing like the one for battery for any input device
/proc/acpi/battery/CMB0/state
or even in /sys/input/devices/XXXX

and let any userspace application do what she wants with information ?

> The problem is that it doesn't really seem to me that all accelerometers
> will be doing hw monitoring. The ones used in laptops, for sure, trying
> to prevent the hd from drying during a fall. But imagine the
> accelerometers used in, say, wii-mote, or cellphones, or such stuff ?

Many of them are HID devices (99%), so can be treated the same way
according the standard.

> Say we wanna use the accelerometer for both screen rotation and gaming,
> that device isn't doing hw monitoring and still we _do_ want to set
> different thresholds and irq requests/types for different use cases,
> right ?

Another reason for preparing the interface I just cited.

> I'll grep around the Industrial IO patchset if that's supposed to a
> 'sensor fw' sorta thing. Hope it does report the devices as input
> devices. I'm pretty sure we're gonna fall into similar issues when
> dealing with magnetometers, for instance, what's the best way to expose
> those device with current linux frameworks ? It's not really user input
> data...
>
> Well, let's see where this discussion takes us. Willing to hear from
> Jonatha, Dmitry and all of you guys

Yes guys, I also wait for your comments :)


ikbel
