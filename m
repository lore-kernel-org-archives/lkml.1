Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYJ3OZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYJ3OZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYJ3OZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:25:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:47320 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYJ3OZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J3+mbwblMV8+jncXaXhX9Pe5BAJFA9VvtgEoWWkohSyf2SJYEZLakUw+yTT9tJarmO
         Uvy7uEp0Z/fr4AKX1SzG4AwwjM7lwOn5q5+GaRsqB6XZV2mWUkOZjGXlSJ1cdhoxP7K7
         SGFCofEDOIMtsQudpxhD5SYK+6exX/4Gs9AnY=
Message-ID: <3aaafc130810300725l1911cd7ay1ba8d33e96c8424b@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:25:30 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Cc: "Moritz Muehlenhoff" <jmm@debian.org>, linux-kernel@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <20081030014246.GA24081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de>
	 <20081028103337.a021e85d.rdunlap@xenotime.net>
	 <20081028181402.GB4873@suse.de> <slrngghcgf.3do.jmm@inutil.org>
	 <3aaafc130810291737i41716bd2r767150b47239b0a1@mail.gmail.com>
	 <20081030014246.GA24081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 9:42 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Oct 29, 2008 at 08:37:54PM -0400, J.R. Mauro wrote:
>> On Wed, Oct 29, 2008 at 2:57 PM, Moritz Muehlenhoff <jmm@debian.org> wrote:
>> > Greg KH wrote:
>> >> Of course, if someone doesn't want their code in the staging tree, I
>> >> will not add it, that's just being "nice".
>> >>
>> >> As for what I will not put into staging, right now I'm sticking with
>> >> drivers only, no filesystems (people have asked already).  I don't think
>> >> we have seen any drivers that I will not put into the staging tree yet.
>> >
>> > Hi Greg,
>> > Great effort with staging, thanks a lot!
>> >
>> > I've had a look at the out-of-tree kernel drivers currently present
>> > in Debian, maybe you want to merge some into staging. The Debian
>> > overview pages contain download links (the orig.tar.gz files):
>> >
>> > Acer hotkey driver:
>> > http://packages.qa.debian.org/a/acerhk.html
>> > http://www.cakey.de/acerhk/
>> >
>> > Synaptics cPad:
>> > http://packages.qa.debian.org/c/cpad-kernel.html
>> > http://www.janerob.com/rob/ts5100/cPad/index.shtml
>> >
>> > 3Dfx driver:
>> > http://packages.qa.debian.org/d/device3dfx.html
>> > http://glide.sourceforge.net/
>> >
>> > et131x Ethernet Controller:
>> > http://packages.qa.debian.org/e/et131x.html
>> > http://sourceforge.net/projects/et131x/
>>
>> This driver (or a driver for the same hardware) is in staging already.
>>
>> >
>> > GPIB (IEEE 488) drivers:
>> > http://packages.qa.debian.org/g/gpib.html
>> > http://linux-gpib.sourceforge.net/
>> >
>> > LEDs driver of PCEngines ALIX 2/3 boards:
>> > http://packages.qa.debian.org/l/leds-alix.html
>> > https://dev.openwrt.org/
>> >
>> > Kernel driver for the back-end scaler on Matrox cards:
>> > http://packages.qa.debian.org/m/mga-vid.html
>> > http://attila.kinali.ch/mga/
>> >
>> > ov51x-jpeg driver:
>> > http://packages.qa.debian.org/o/ov51x-jpeg.html
>> > http://www.rastageeks.org/ov51x-jpeg/index.php/Main_Page
>> >
>> > tp_smapi kernel modules:
>> > http://packages.qa.debian.org/t/tp-smapi.html
>> > http://tpctl.sourceforge.net/
>> >
>> > Voicetronix telephony hardware:
>> > http://packages.qa.debian.org/v/vpb-driver.html
>> > http://www.voicetronix.com.au/
>>
>> Greg,
>>
>> If you're interested in having the above drivers get into staging and
>> need someone to email the developers about it, I humbly volunteer.
>
> Please do, that would be wonderful.
>
> I'll go add these packages to my big "spreadsheet o' drivers" I'm trying
> to use to track all of this mess...
>
> thanks,
>
> greg k-h
>

Ok. I emailed a few of them. The ones I omitted either didn't have a
clear homepage/maintainer, had already sent a patch to the kernel, or
explicitly stated no intentions of going into mainline.

Maybe you could send me the Spreadsheet O' Drivers if you need more help?

I've also been wondering: should we contact the maintainers of the big
distros and make them aware of staging and have them work with us to
get whatever out-of-tree stuff they have more centralized? I don't
know if it's a good idea, but it could be. And if it is, I have no
idea where to start.
