Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZLCVvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZLCVvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZLCVvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:51:07 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:57990 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZLCVvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R95kq4v0ywLg/lwNS5SatjmTXeCwCfybfHGO57Oyb+0YVLfJNqcZSFWS2DUA32iEg2
         iCljmUSFHdCfuB9PCoaYfUZBcj4w2sj7OoQYAwSY0p0vuE8zOlBWhqG5mb22iQAbOVRy
         r2+pLUNhIGDvlbTXinMOShyx9q/Jw7Il8jg2k=
Message-ID: <4B1832CD.5040809@garzik.org>
Date: Thu, 03 Dec 2009 16:51:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032045.48728.bzolnier@gmail.com> <4B182A9F.5090708@garzik.org> <200912032242.05785.bzolnier@gmail.com>
In-Reply-To: <200912032242.05785.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 04:42 PM, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 03 December 2009 10:16:15 pm Jeff Garzik wrote:
>
>>>         pata_efar: MWDMA0 is unsupported
>>
>> skipped, pending discussion (just sent email)
>
> The discussion was there, you were not especially interested
> (http://lkml.org/lkml/2009/11/26/343).

I reviewed the discussion before adding an email to that thread.


>>>         pata_hpt3x2n: fix overclocked MWDMA0 timing
>>
>> skipped, pending discussion (just sent email)
>
> ditto (http://lkml.org/lkml/2009/11/27/257).

I reviewed the discussion before adding an email to that thread.


> There were no complains so I'm pretty sure Sergei was fine with it.

It was unclear, hence I sent email for clarification.


>>>         pata_hpt3x3: Power Management fix
>>
>> applied, on a hope and a prayer (did not see this posted to mailing
>> list?).  It looks correct to me.
>
> I prefer sticking to technical facts. ;)
>
> Patch was posted to both mailing lists: http://lkml.org/lkml/2009/11/25/321

Whoops, I indeed missed this one.


>>>         pata_via: clear UDMA transfer mode bit for PIO and MWDMA
>>
>> applied -- even though Alan's comment was correct.  It is standard
>> kernel practice to place cosmetic changes into their own patches,
>> because it is standard kernel practice to break up logically distinct
>> changes.
>
> We are talking about:
>
>   pata_via.c |   19 +++++++++++++------
>   1 file changed, 13 insertions(+), 6 deletions(-)
>
> patch here (http://lkml.org/lkml/2009/11/25/380) and cosmetic change
> is clearly documented in the patch description.
>
>
> Do people really wonder why I find upstream to be too much hassle to
> deal with?

The thousand other kernel developers seem to be able to split up their 
patches, separating out cosmetic changes from functional ones.  It has 
clear engineering benefits, and has been standard practice for a decade 
or more.

Why is it such an imposition for your patches to look like everyone 
else's?  And by "everyone", I mean all other kernel developers, not just 
other ATA developers.

You seem to consider standard kernel practice a hassle.  Separating out 
cosmetic changes is not only a libata practice, it is the norm for the 
entire kernel.

	Jeff


