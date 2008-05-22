Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYEVS1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYEVS1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYEVS1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:27:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:55421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYEVS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=So440fI0NkJSTLl7f5KI+uern+2m5fhc97cbjclkbfj1D94z5UgRDS7XtRPj2bVn/6wTy8tkKIEaXQBWkstOsW/O86EP+Q86fmvsifbNrDxUM+XocUplW1iOiyvb9qJiBjPozL+zPzK5yb6DN+iJikqZ1eeito+aRbcfYphIbHQ=
Message-ID: <7b9198260805221127w9b241a7q4869fcdede030a1d@mail.gmail.com>
Date: Thu, 22 May 2008 19:27:12 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.24 not recognizing 2G MMC card?
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <20080522182217.GA10760@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080521172104.GC2592@fieldses.org>
	 <7b9198260805211101s1fb96533tc86a614008833741@mail.gmail.com>
	 <20080522033822.GD14376@fieldses.org>
	 <7b9198260805221110gb4df390t67d6bd9c812d71da@mail.gmail.com>
	 <20080522182217.GA10760@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/22 J. Bruce Fields <bfields@fieldses.org>:
> On Thu, May 22, 2008 at 07:10:22PM +0100, Tom Spink wrote:
>> 2008/5/22 J. Bruce Fields <bfields@fieldses.org>:
>> > On Wed, May 21, 2008 at 07:01:10PM +0100, Tom Spink wrote:
>> >> 2008/5/21 J. Bruce Fields <bfields@fieldses.org>:
>> >> > Please forgive a somewhat naive question--I'm not sure how to go about
>> >> > debugging this kind of thing:
>> >> >
>> >> > I have a Dell 1420n with card readers reported by lspci as:
>> >> >
>> >> > 03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
>> >> > 03:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
>> >> >
>> >> > I have a 512MB MicroSD card which seems to be recognized fine, but a 2GB
>> >> > MMC card is not.
>> >> >
>> >> > I'm using a stock Ubuntu 8.04 kernel, which reports itself as
>> >> > 2.6.24-16-generic.
>> >> >
>> >> > Skimming through commits to drivers/mmc,
>> >> > 5ae70296c85f96a9969891d9de3410ebdf210b71 "mmc: Disabler for Ricoh MMC
>> >> > controller", looks relevant, but seems to be included in 2.6.24.
>> >> >
>> >> > Anything I should try?  Thanks in advance for any suggestions.
>> >> >
>> >> > --b.
>> >>
>> >> Hi,
>> >>
>> >> What does: lsmod | grep ricoh, give you?  Anything?
>> >
>> > root@pig:/home/bfields# lsmod | grep ricoh
>> > ricoh_mmc               4352  0
>> >
>> > --b.
>> >
>>
>> So does the MMC card work on other card readers, i.e. it's not
>> damaged?
>
> I use it in a Nokia 770, and it works there.
>
> It needs an adapter for the laptop which it doesn't need for the 770;
> googling around.... Something that looks like this:
>
>        http://www.globemaster.com.tw/data/rs mmc adapter.jpg
>
> So I suppose the adapter could be broken.  Seems unlikely,
> though--doesn't look like it does anything more than make the card
> fit physically in the slot.

Hmm.  It is worth a check, given your next response...

>
>> When you plug the card into the reader, can you check dmesg
>> and see if there's any relevant information in there, and post it
>> here?
>
> It doesn't trigger any dmesg output at all.

Interesting.  I'd expect to see something appearing about the card.
I'm afraid I'm not sure what to suggest next, if there's no debug
output.

>
> --b.
>

-- 
Tom Spink
