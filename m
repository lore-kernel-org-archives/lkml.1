Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbZDFTeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbZDFTeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZDFTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:34:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33631 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZDFTd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xOxWhJM1oUX7aLM6F6NmH9kUUyBM4zU6mUR1uQNyBQr5haCsvn4GZtIjhW0bcztQ8n
         9BN4Cv6ti08nbJUk+wOYp7FMCbUFvqo2OlmvVZgxSb1HOruFBM9Dpabqin/GJRJBxTck
         ugY8UG/jZzs39YfzirbTop/+jr59QFQ2ibeWI=
MIME-Version: 1.0
In-Reply-To: <20090406150431.GA25557@kroah.com>
References: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com>
	 <20090406022356.GA866@kroah.com>
	 <19ac3f7a0904060211s5a79b659tf8ac315010151dbb@mail.gmail.com>
	 <20090406150431.GA25557@kroah.com>
Date: Mon, 6 Apr 2009 20:33:56 +0100
X-Google-Sender-Auth: 14625823ebc6606f
Message-ID: <19ac3f7a0904061233i7a889cebr86a73fe02cb34421@mail.gmail.com>
Subject: Re: USB disconnect, address 6
From: Jon Grant <jg@jguk.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2009/4/6 Greg KH <greg@kroah.com>:
> On Mon, Apr 06, 2009 at 11:11:55AM +0200, Jon Grant wrote:
[..]
>> The idea was that the disconnect could give more information.
>> Otherwise it's necessary to go hunting back up the log to track down
>> which USB device was the one disconnected (which works fine, but isn't
>> ideal for time consumed doing this regularly).
>
> As you yanked the device out, don't you know which one it was?

I do get devices disappear without me disconnecting them, various
different PCs, and laptops.

[..]
>> Apr  5 18:56:58 data-laptop kernel: usb 5-1: USB disconnect, address 6
>> (Samsung  Mighty Drive)
>>
>> Would this not be clearer?
>
> That might be nice, but note that the kernel doesn't even know the
> strings after a device is gone, as it had to read them from the device
> :)

Yeah, would need to cache the names, perhaps you don't want to bloat
the kernel that way.

> Also, lots of devices don't have strings describing them, and some of
> them are just flat out wrong.  And, if you have multiple devices of the
> same type, it wouldn't really help out any either.

Well personally I would rather at least know the class of the device
which went, and would put up with incorrect info in preference to no
info.

> So it would be a bit difficult to do this, sorry.

Thanks anyway for considering it.

Best regards, Jon
