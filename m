Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbXBUWHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbXBUWHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXBUWHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:07:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:41635 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXBUWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pb+d4c2wxeRPOftpiQHLqIqfGztlId7Xgu2AAkx4qkwDRGL/exnI0yc0sg3lxZgnI4arxYkj+6ugah0oeHOU3ahsHcmGeIWvfOODbIfHF0MvkQSagklmcTJAMuJLGhqg0cXDhuwYolshvsYcCkKSKWZdfcgcPwtVoHlWZwKdU6g=
Message-ID: <4727185d0702211407n66478752laaa182418479db9c@mail.gmail.com>
Date: Wed, 21 Feb 2007 23:07:21 +0100
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: "Patrick Ale" <patrick.ale@gmail.com>
Subject: Re: libsata doesn't like bus without master
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8d158e1f0702211301n3d30f590t14b1501e418da7e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4727185d0702211241v63549a77ye1023e9ff802c24a@mail.gmail.com>
	 <4727185d0702211247r796a2f4fte8b9511aa6864452@mail.gmail.com>
	 <8d158e1f0702211301n3d30f590t14b1501e418da7e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> But serious, The second "abnormal" error "ATA: abnormal status 0x8 on
> port 0xF88597DF", I got feedback from, by Tejun. He confirmed that, as
> I thought, this was a cosmectic error messages for "No devices found".

I get 0x7F, but already knew it was harmless, I think Tejun enlightened
me about that some time ago...

> The first one got some debate as if it was legal to have a slave
> without a master and all and the last thing I saw written on this
> email that we (that is, the linux developers and the maintainers, I
> dont code anything other than 'Hello world' and even that might
> segfault) should support it and if we dont yet, fix it.

Yep, I read that, at the same time as your other messages from
linux-ide, and a reply I got from Alan asking for the bug report, so
I reported what I got.

> Question for you tho, since I have two laptops with the same chipset
> and more ore less same configuration (Siemens LifeBook E series with
> the same DVD writer and an HP laptop), do you use native SATA mode? or
> Legacy/Compatible mode?

Don't thik I saw that as configurable in that BIOS.
[checking...]
No there is no such settings...

> In the latter case it might explain why you see one master connected
> to one bus and a slave to the other. If you use legacy SATA mode you
> should just see drive 0 and drive 1.

Maybe, or it is just the fact that is a strange laptop from a little .ch
vendor...

> At least, that's how it works here :)

I wish I could make it work here too ;-)

-- 
Vincent Legoll
