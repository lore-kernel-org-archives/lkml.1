Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbZHGNCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbZHGNCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbZHGNCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:02:14 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:44910 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbZHGNCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:02:13 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 09:02:12 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YTrXKQLSrYminpkoZjpnnmxPRXqd+lTe98qRcWX+coEisrexX4ii3vaiYNk0QskOWM
         dhJ1CZGeuIBZBQcKf5nnw4hXA53ImFIRRdgvjfufCl39c9nuwacwf7vP3xa8xCRHFNyu
         lebhKRZ47SjIL+36bP6rtn72mIjO04utQnYcA=
MIME-Version: 1.0
In-Reply-To: <200908071324.45269.elendil@planet.nl>
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com>
	 <200908071324.45269.elendil@planet.nl>
Date: Fri, 7 Aug 2009 13:56:43 +0100
Message-ID: <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com>
Subject: Re: ath5k - strange regulatory domain change
From: Chris Clayton <chris2553@googlemail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Frans,

2009/8/7 Frans Pop <elendil@planet.nl>:
> Chris Clayton wrote:
>> Because of some problems with my Belkin Wireless G card  (model
>> F5D7010) and the rt61pci driver, I've started to use a "no-name" card
>> that is supported by the ath5k driver.
>>
>> A problem is that I have come across is that for some reason the CN
>> regulatory domain is being set automatically. This doesn't happen with
>> the Belkin (rt61) card. I have the following line in
>> /etc/modprobe.d/modprobe.conf to set the regulatory domain to GB:
>>
>> options cfg80211 ieee80211_regdom=GB
>
> This issue has already been discussed extensively (after I reported it).
> Please see the following thread: http://lkml.org/lkml/2009/7/8/421. It
> contains a lot of information from the wireless maintainers.
>

To sum this up then (as I understand things):

1. I am the system administrator (root);
2. I am using a valid (albeit deprecated from 2.6.31) method to tell
the wireless infrastructure that I want the regulatory domain set to
GB;
3. GB is a valid code; and
4. the wireless infrastructure sets the regulatory domain to CN.
5. in 2.6.30, the wireless infrastructure does what I (the root user)
tell it to do.

That's a regression in my book. Oh well! I do have the iw and crda
applications installed, so I've taken that route of setting the
regulatory domain to GB.

Interestingly, if I make no attempt to set the regulatory domain at
all, it get sets to World and CN never comes into it. It's only if I
try to set it to GB via the module parameter that it gets set to CN.
To me, that seems broken.

Thanks again,

Chris

> Cheers.
> FJP
>



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
