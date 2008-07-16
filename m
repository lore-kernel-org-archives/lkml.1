Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYGPDFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYGPDFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbYGPDF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:05:26 -0400
Received: from hs-out-0708.google.com ([64.233.178.246]:47001 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbYGPDFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RDOCBgvmzFiv6LfyKqgG7hAzXj5EQa63PsiSpY25Qzfh4TvaNUThKTBGhhATJAmx/h
         9thPXPJ61sB9VT05oxWIwLel++fTBj1ByCrYHydgDc/nx9bJY4sqRksGsTQlTtnfgg9M
         +fKCHn7i6zdjIuFrC8jldMWbLqE/+Gd66VGts=
Message-ID: <dd18b0c30807152005g3c58001br7182f7670d6247db@mail.gmail.com>
Date: Wed, 16 Jul 2008 03:05:23 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080716012427.GA27398@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com>
	 <20080715231118.GA26807@bromo.msbb.uc.edu>
	 <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com>
	 <20080716012427.GA27398@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 1:24 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> Justin,
>    You also download the x86_64 iso instead from...
>
> http://mirrors.kernel.org/fedora/development/x86_64/os/images/
>
> Both should give you the same kernel boot freeze that I am
> seeing (assuming that the kernel boots up with the message
> "Not using MMCONFIG". At this point I am just trying to find
> out if anyone else can reproduce this issue on a MacBook Pro
> (second generation). Otherwise I am going to be out of luck
> when distros switch to 2.6.26.
>                          Jack
> ps I am currently guessing that thet actual freeze is
> occuring in the code that is executed right after...
>
> pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
>
> but before...
>
> PCI: Transparent bridge - 0000:00:1e.0
>
> ...which never appears here under 2.6.26.
>
>
>
>
> On Wed, Jul 16, 2008 at 12:26:05AM +0000, Justin Mattock wrote:
>> >
>>
>> Ah I see, so this is from a fresh .iso image
>> I can give you're suggestion a try(need to locate a blank cd)
>> keep in mind the .iso might not have x86 support i.g.
>> I use nubuntu(why: it's small) one of the problems I was facing was
>> the alpha release, which did not support x86(when using that .iso image
>> it would start booting and then spit out a bunch of messages vertically,
>> but a few month's later they released there .iso with support thus
>> giving me the opportunity to use it.
>> This might be what you are dealing with.
>> regards;
>>
>> --
>> Justin P. Mattock
>

I have not yet tried the .iso's yet.
(busy with other things at the moment),
from what you're telling me it seems they must have left out
something in the .config. "Shit" this means you can't even load the .iso itself
for the initial install. Maybe you should let them know about this(I
don't use fedora that much)
If need be, try a stable version of the O.S(fedora). so you can load
2.6.26, and then if time permits
you, update to that of the development version.(that is until you get
an answer from the
maintainers of this .iso with the issue).
regards;

-- 
Justin P. Mattock
