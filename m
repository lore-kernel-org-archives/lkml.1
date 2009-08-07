Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbZHGO5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbZHGO5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbZHGO5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:57:32 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:52638 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbZHGO5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jrkg3429luZigV9tYXDOoauBfyySt2WfjXlsJul18a2CImGqLhBkG3P+wo/ZxA5yCb
         gN7gdo0ZcmyyYL5xE8/6KeWVGp7f6BhHGOVYplQ0kvuD+04e2Pwm+Rohxi8jfPqI52t5
         mtop52ZeyL9Lif02nq3LoXDL8c6KZ9lQ6/wqY=
MIME-Version: 1.0
In-Reply-To: <20090807134803.GA7545@tuxdriver.com>
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com>
	 <200908071324.45269.elendil@planet.nl>
	 <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com>
	 <20090807134803.GA7545@tuxdriver.com>
Date: Fri, 7 Aug 2009 15:57:30 +0100
Message-ID: <c6b1100b0908070757t7b973180s17959e0f46347d5d@mail.gmail.com>
Subject: Re: ath5k - strange regulatory domain change
From: Chris Clayton <chris2553@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Frans Pop <elendil@planet.nl>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

2009/8/7 John W. Linville <linville@tuxdriver.com>:
> On Fri, Aug 07, 2009 at 01:56:43PM +0100, Chris Clayton wrote:
>> Thanks Frans,
>>
>> 2009/8/7 Frans Pop <elendil@planet.nl>:
>> > Chris Clayton wrote:
>> >> Because of some problems with my Belkin Wireless G card  (model
>> >> F5D7010) and the rt61pci driver, I've started to use a "no-name" card
>> >> that is supported by the ath5k driver.
>> >>
>> >> A problem is that I have come across is that for some reason the CN
>> >> regulatory domain is being set automatically. This doesn't happen with
>> >> the Belkin (rt61) card. I have the following line in
>> >> /etc/modprobe.d/modprobe.conf to set the regulatory domain to GB:
>> >>
>> >> options cfg80211 ieee80211_regdom=GB
>> >
>> > This issue has already been discussed extensively (after I reported it).
>> > Please see the following thread: http://lkml.org/lkml/2009/7/8/421. It
>> > contains a lot of information from the wireless maintainers.
>> >
>>
>> To sum this up then (as I understand things):
>>
>> 1. I am the system administrator (root);
>> 2. I am using a valid (albeit deprecated from 2.6.31) method to tell
>> the wireless infrastructure that I want the regulatory domain set to
>> GB;
>> 3. GB is a valid code; and
>> 4. the wireless infrastructure sets the regulatory domain to CN.
>> 5. in 2.6.30, the wireless infrastructure does what I (the root user)
>> tell it to do.
>>
>> That's a regression in my book. Oh well! I do have the iw and crda
>> applications installed, so I've taken that route of setting the
>> regulatory domain to GB.
>
> Are you actually getting the wrong regulatory rules enforced?  Or are
> you merely bothered that it is reporting "CN" instead of "GB"?
>

I'm not sure whether it's wrong or not. To these dmesg snippets from
my original post look wrong because one of the frequency ranges listed
for CN is outside those listed for GB and one of the CN max_eirp
entries is not preent in the GB list. Whether that is OK or not I
don't know and can't find (lay user) documentation to tell me.

cfg80211: Regulatory domain changed to country: GB
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)

cfg80211: Regulatory domain changed to country: CN
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (N/A, 3000 mBm)


Thanks

Chris

> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
