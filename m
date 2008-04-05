Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbYDEGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbYDEGoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 02:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYDEGoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 02:44:05 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:45545 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYDEGoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 02:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YjvGwP7aXVip3gRqZKL58dQl6raj4JtTARmtbOes3ayHv+YNC91XMijtJfXDCTcxdeWCZr46nHqte4vjPUHQn4hWJv2dgtHfshdLGQPeTB8z9WiqMjK9DMnHbPaJy8yepHBcL5ctHJLFLoLiJIEkjqNyaL3zypny5UvLfUcmtZI=
Message-ID: <dd18b0c30804042344we0e62a0s8cd2c7e8137a9e8@mail.gmail.com>
Date: Sat, 5 Apr 2008 06:44:02 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: 2.6.25 intended change: smc:kbd_backlight vs. smc::kbd_backlight ?
Cc: rpurdie@rpsys.net, "Julien BLACHE" <jb@jblache.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1207373556.10237.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207162690.9669.11.camel@localhost>
	 <1207292068.4511.10.camel@localhost>
	 <dd18b0c30804040812x76f99af7o99fa57c9a1ec10bc@mail.gmail.com>
	 <1207373556.10237.2.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; there must be some kind of reason for the change from ":" to
"::" smc::kbd_backlight, maybee something with the kernel spitting
out:

[  464.524630] applesmc: wait status failed: 5 != 4
[  464.727477] applesmc: wait status failed: c != 8
[  606.219666] applesmc: wait status failed: 5 != 4
[  606.421338] applesmc: wait status failed: c != 8
[  656.152925] applesmc: wait status failed: 5 != 4
[  656.358032] applesmc: wait status failed: c != 8
[  743.488092] applesmc: wait status failed: 5 != 4
[  743.687861] applesmc: wait status failed: c != 8
[ 1559.745211] applesmc: wait status failed: 5 != 4
[ 1559.946876] applesmc: wait status failed: c != 8
[ 1617.527543] applesmc: wait status failed: 5 != 4
[ 1617.733097] applesmc: wait status failed: c != 8
[ 1855.794475] applesmc: wait status failed: 5 != 4
[ 1855.997410] applesmc: wait status failed: c != 8
[ 2062.038870] applesmc: wait status failed: 5 != 4
[ 2062.240451] applesmc: wait status failed: c != 8
[ 2145.673882] applesmc: wait status failed: 5 != 4
[ 2145.874891] applesmc: wait status failed: c != 8
[ 2226.070113] applesmc: wait status failed: 5 != 4
[ 2226.275480] applesmc: wait status failed: c != 8
[ 2233.295702] applesmc: wait status failed: 5 != 4
[ 2233.501599] applesmc: wait status failed: c != 8
[ 2490.349096] applesmc: wait status failed: 5 != 4
[ 2490.554648] applesmc: wait status failed: c != 8
[ 2526.524932] applesmc: wait status failed: 5 != 4
[ 2526.727963] applesmc: wait status failed: c != 8
[ 2994.653714] applesmc: wait status failed: 5 != 4
[ 2994.856479] applesmc: wait status failed: c != 8
[ 3556.760811] applesmc: wait status failed: 5 != 4
[ 3556.960414] applesmc: wait status failed: c != 8
[ 4104.040447] applesmc: wait status failed: 5 != 4
[ 4104.241539] applesmc: wait status failed: c != 8
[ 4183.083313] applesmc: wait status failed: 5 != 4
[ 4183.283102] applesmc: wait status failed: c != 8
[ 4405.815336] applesmc: wait status failed: 5 != 4
[ 4406.013374] applesmc: wait status failed: c != 8
[ 4828.790663] applesmc: wait status failed: 5 != 4
[ 4828.990296] applesmc: wait status failed: c != 8
[ 5001.422026] applesmc: wait status failed: 5 != 4
[ 5001.624074] applesmc: wait status failed: c != 8
[ 5054.881643] applesmc: wait status failed: 5 != 4
[ 5055.085512] applesmc: wait status failed: c != 8
[ 5091.950244] applesmc: wait status failed: 5 != 4
[ 5092.153377] applesmc: wait status failed: c != 8
[ 5142.416144] applesmc: wait status failed: 5 != 4
[ 5142.619838] applesmc: wait status failed: c != 8
[ 5201.180057] applesmc: wait status failed: 5 != 4
[ 5201.378893] applesmc: wait status failed: c != 8
[ 6071.409386] applesmc: wait status failed: 5 != 4
[ 6071.611533] applesmc: wait status failed: c != 8
[ 6563.512077] applesmc: wait status failed: 5 != 4
[ 6563.711152] applesmc: wait status failed: c != 8
[ 6775.019376] applesmc: wait status failed: 5 != 4
[ 6775.218753] applesmc: wait status failed: c != 8
[ 7028.430958] applesmc: wait status failed: 5 != 4
[ 7028.631925] applesmc: wait status failed: c != 8
[ 7069.534835] applesmc: wait status failed: 5 != 4
[ 7069.734629] applesmc: wait status failed: c != 8
[ 7222.764415] applesmc: wait status failed: 5 != 4
[ 7222.964181] applesmc: wait status failed: c != 8
[ 7229.991367] applesmc: wait status failed: 5 != 4
[ 7230.194062] applesmc: wait status failed: c != 8
[ 7250.619742] applesmc: wait status failed: 5 != 5
[ 7250.819656] applesmc: wait status failed: c != 8
[ 7890.440161] applesmc: wait status failed: 5 != 4
[ 7890.641210] applesmc: wait status failed: c != 8
[ 8048.801254] applesmc: wait status failed: 5 != 4
[ 8049.001035] applesmc: wait status failed: c != 8
[ 8170.854568] applesmc: wait status failed: 5 != 4
[ 8171.059915] applesmc: wait status failed: c != 8
[ 8747.146058] applesmc: wait status failed: 5 != 4
[ 8747.345261] applesmc: wait status failed: c != 8
[ 9034.362620] applesmc: wait status failed: 5 != 4
[ 9034.568220] applesmc: wait status failed: c != 8

I'm tired of seeing this, how to get rid of this regression if you
want to call this that.?
regards;
               Justin P. Mattock

On Sat, Apr 5, 2008 at 5:32 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Fri, 2008-04-04 at 15:12 +0000, Justin Mattock wrote:
>  > Hello; I noticed this as well, you loose the greatest feature; the
>  > cool leds lights on the keyboard with the macbook pro,
>  > A solution that worked for me was to compile pommed from the source
>  > and edit kbd_backlight.h
>  > regards;
>  >                Justin P. Mattock
>
>  Yeah, but it will not only affect pommed... and I don't see the
>  rationale of introducing :: to separate things... so I think we should
>  have another patch replacing the :: with ':' again to unbreak userspace
>  for 2.6.25.
>
>  Could someone more official please respond to this regression (CCing
>  Rafael to record it)
>
>  Soeren
>
>  > On Fri, Apr 4, 2008 at 6:54 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
>  > > On Wed, 2008-04-02 at 20:58 +0200, Soeren Sonnenburg wrote:
>  > >  > Dear all,
>  > >  >
>  > >  > I am wondering whether the change from
>  > >  >
>  > >  > /sys/devices/platform/applesmc.768/leds/smc:kbd_backlight  (2.6.24)
>  > >  > /sys/devices/platform/applesmc.768/leds/smc::kbd_backlight (2.6.25)
>  > >  >
>  > >  > is intentional?
>  > >  >
>  > >  > I recognized that it breaks current userspace applications changing the
>  > >  > keyboard background leds like pommed...
>  > >
>  > >  OK it looks like commit 6c152beefbf90579d21afc4f7e075b1f801f9a75 from
>  > >  Richard Purdie, 'leds: Standardise LED naming scheme' introduced this
>  > >  change.
>  > >
>  > >  Why do we need '::' instead of a single ':' (that would not have broken
>  > >  things)?
>  > >
>  > >  Also sometimes only a single ':' seperator is used like in
>  > >  corgi:green:mail but e.g. not in clevo::mail ?!
>  > >
>  > >  Soeren
>  > >  --
>  > >  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  > >  the body of a message to majordomo@vger.kernel.org
>  > >  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  > >  Please read the FAQ at  http://www.tux.org/lkml/
>  > >
>  >
>  >
>  >
>



-- 
Justin P. Mattock
