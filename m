Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZICIfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZICIfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZICIfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:35:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63275 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZICIfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fe4ArY5q0He+CX0OZXU5EywbvhRE/7tZveJqu/Dn69x2E0HmNqiWQb4EqMj1qyfCne
         sHcyOCKLNSvVeZdBiTtnGvxL8hfvU4jWP622nkmOMsjLNzjsSaRVFGY84Z1q9iY3MTy3
         2tdbiPrF5ULrkjRBTpSrVSzkkLz6BZdRlbLuo=
MIME-Version: 1.0
In-Reply-To: <1251945918.3483.267.camel@rzhang-dt>
References: <1251789947.3483.215.camel@rzhang-dt>
	 <9b2b86520909021222k6cc49456vc3232e488eef9e37@mail.gmail.com>
	 <1251945918.3483.267.camel@rzhang-dt>
Date: Thu, 3 Sep 2009 09:35:52 +0100
Message-ID: <9b2b86520909030135v73319621g39225ef5191a28f0@mail.gmail.com>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/09, Zhang Rui <rui.zhang@intel.com> wrote:
> On Thu, 2009-09-03 at 03:22 +0800, Alan Jenkins wrote:
>> On 9/1/09, Zhang Rui <rui.zhang@intel.com> wrote:
>> >
>> > Introduce ALS sysfs class.
>> >
>> > ALS sysfs class provides a standard sysfs interface for
>> > Ambient Light Sensor devices.
>> >
>> > please read Documentation/ABI/testing/sysfs-class-als for
>> > detailed sysfs designs.
>> >
>> > ﻿CC: Pavel Machek <pavel@ucw.cz>
>> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>> > ---
>>
>> > +++ linux-2.6/drivers/als/Kconfig
>> > @@ -0,0 +1,10 @@
>> > +#
>> > +# Ambient Light Sensor sysfs device configuration
>> > +#
>> > +
>> > +menuconfig ALS
>> > +	tristate "Ambient Light Sensor sysfs device"
>> > +	help
>> > +	  This framework provides a generic sysfs interface for
>> > +	  Ambient Light Sensor devices.
>> > +	  If you want this support, you should say Y or M here.
>>
>> Gratuitous nitpick:
>> Can this option be made non-visible (or hidden behind CONFIG_EMBEDDED)?
>>
>> Maybe you copied the pattern of the thermal sysfs interface - but the
>> ACPI thermal driver is useful to keep your computer cool even without
>> the sysfs interface.  ALS drivers are useless without the sysfs
>> interface, no?
>>
> ACPI ALS device driver is the first user of this sysfs class.
> I think there will be more native ALS device drivers in the future,
> which locate at drivers/als/ and depends on CONFIG_ALS.
>
> thanks,
> rui

Oh!  So it may become a menu like e.g. hwmon.

Thanks for the explanation
Alan
