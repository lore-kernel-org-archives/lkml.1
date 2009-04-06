Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZDFUJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZDFUJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZDFUIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:08:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:2452 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZDFUIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rJxo3kFbHon0fJe9bFPDU50dFRQxRhLu+4A8j723oiRC3+zlyavK1Ga4dYGrhXahCg
         BBRPcptwhFvPtdGG53CGouEygHfjnqc+qWeJiaLTdTazk7ClufUZ+NSslDeJcos3auN/
         mKmKi+DezHjb5p2a4kfMNYa6DmqBE8pZWIVhI=
MIME-Version: 1.0
In-Reply-To: <19ac3f7a0904061233i7a889cebr86a73fe02cb34421@mail.gmail.com>
References: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com>
	 <20090406022356.GA866@kroah.com>
	 <19ac3f7a0904060211s5a79b659tf8ac315010151dbb@mail.gmail.com>
	 <20090406150431.GA25557@kroah.com>
	 <19ac3f7a0904061233i7a889cebr86a73fe02cb34421@mail.gmail.com>
Date: Mon, 6 Apr 2009 16:08:50 -0400
Message-ID: <3aaafc130904061308oc8a40bfwefe7199cfb9369aa@mail.gmail.com>
Subject: Re: USB disconnect, address 6
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Jon Grant <jg@jguk.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 3:33 PM, Jon Grant <jg@jguk.org> wrote:
> Hi
>
> 2009/4/6 Greg KH <greg@kroah.com>:
>> On Mon, Apr 06, 2009 at 11:11:55AM +0200, Jon Grant wrote:
> [..]
>>> The idea was that the disconnect could give more information.
>>> Otherwise it's necessary to go hunting back up the log to track down
>>> which USB device was the one disconnected (which works fine, but isn't
>>> ideal for time consumed doing this regularly).
>>
>> As you yanked the device out, don't you know which one it was?
>
> I do get devices disappear without me disconnecting them, various
> different PCs, and laptops.
>
> [..]
>>> Apr  5 18:56:58 data-laptop kernel: usb 5-1: USB disconnect, address 6
>>> (Samsung  Mighty Drive)
>>>
>>> Would this not be clearer?
>>
>> That might be nice, but note that the kernel doesn't even know the
>> strings after a device is gone, as it had to read them from the device
>> :)
>
> Yeah, would need to cache the names, perhaps you don't want to bloat
> the kernel that way.
>
>> Also, lots of devices don't have strings describing them, and some of
>> them are just flat out wrong.  And, if you have multiple devices of the
>> same type, it wouldn't really help out any either.
>
> Well personally I would rather at least know the class of the device
> which went, and would put up with incorrect info in preference to no
> info.

You could perhaps write a script that could look through the logs and
infer which device it was without touching the kernel at all.

>
>> So it would be a bit difficult to do this, sorry.
>
> Thanks anyway for considering it.
>
> Best regards, Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
