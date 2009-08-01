Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZHAOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZHAOKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 10:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZHAOKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 10:10:54 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60761 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZHAOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 10:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DeGhlRh3Nt7jRBjpg9QSbbf3L7VIe6hRuxrY0GaAmanTwzC8htkHBqAa+hk20HjK0U
         EUebB6j6zxio5NSxYENp/Kpzqn7/qDKsLgDzxFNpW4Y7gHDZvnf4Yenszn9u9u6AAsZN
         WgoWoZPF3WbTXc7QdB7KUWcKV0P81MC4ycXfU=
MIME-Version: 1.0
In-Reply-To: <4A6F30AF.4000004@mnementh.co.uk>
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
	 <4A6F0123.9040809@mnementh.co.uk>
	 <Pine.LNX.4.64.0907281556160.6219@axis700.grange>
	 <4A6F30AF.4000004@mnementh.co.uk>
Date: Sat, 1 Aug 2009 18:10:52 +0400
Message-ID: <bc64b4640908010710w1a0d6344s3e810433c28aadd5@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Sorry for the delay,

2009/7/28 Ian Molton <ian@mnementh.co.uk>:
> Guennadi Liakhovetski wrote:
>
>> Hi Ian
>
> Hi!
>
>> Thanks for the review.
>
> No problem - I hope you dont feel that I am picking on you in particular
> here, this problem is not isolated to your patches.
>
>> I understand your concerns. Of course, the _proper_ solution would be to
>> implement an architecture-independent clock API, something like what
>> clocklib was trying to do. So, yes, if clocklib were in place now, I
>> certainly would have used it.
>
> Which is of course a chicken/egg situation. I dealt with this a number of
> times during the e-series development, and every time, integration with
> mainline has gone more swiftly and with better quality, when the job was
> done properly to begin with.
>
>> I searched for those clocklib submission attempts (Dmitry added to CC).
>
> Also adding RMK to the CC:
>
>> Last one I can find (maybe I missed some) is from July 2008 - more than a
>> year ago. So, looks like our options currently are:
>>
>> 1. wait for new submissions of clocklib - if any are planned
>
> Dmitry: whats the current status of your clocklib work?

It wasn't refreshed since last submission or so, since for ARM we do have
rmk's clocks implementations and I other maintainers (except AVR32 IIRC)
didn't care at all.

>> 3. take over patches from Dmitry and bring them to a state acceptable for
>> mainline
>
> Take over / collaborate with. I'll happily help people push these patches.
>
>> I personally don't have free (as in beer) time to work on 2 or 3. Anyone?
>
> If I can find out what the current state of this stuff is, I'll help get it
> working - I can test / update all the TC6x and T7x MFD devices (and probably
> asic3 too)

I don't think I'll have time to work on/refresh clocklib patches. Feel
free to continue
where I've left them.


-- 
With best wishes
Dmitry
