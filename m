Return-Path: <linux-kernel-owner+w=401wt.eu-S934263AbXJPQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263AbXJPQfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764880AbXJPQfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:35:19 -0400
Received: from ag-out-0708.google.com ([72.14.246.245]:22610 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762285AbXJPQfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Wk9bQZJ5NIDpUIWssO/fXcKno6Za21pG3MoU4OSjJwUkQgeJ7sd9m3A7vT0oimGHkGTpeWFhrbeYpTsXdRKzMtL6ClPSbJ6UvGcxOJhYJLLlgw+zWdIOTmkwkT5ZFSwwUIPuWNQqRccNA+svT9FuPLIncNhGr9QSB0TBgpkg2dg=
Message-ID: <4714E842.8020105@gmail.com>
Date: Tue, 16 Oct 2007 20:35:14 +0400
From: Konstantin Kalin <konstantin.kalin@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com>	<20071016154313.53d19c43@the-village.bc.nu>	<4714D5B8.8020301@redhat.com> <20071016164354.6f4e530a@the-village.bc.nu> <4714E02D.7040804@garzik.org>
In-Reply-To: <4714E02D.7040804@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm sorry, but I think that Alan proposed in the first email is more 
than a hack. It would solve the issue for different versions and the 
check is trivial. Or am I mistaken?

Thank you,
Kostya.

Jeff Garzik wrote:
> Alan Cox wrote:
>>> See the below for another report of this:
>>>
>>> http://marc.info/?t=119215716900001&r=1&w=2
>>>
>>> And apparently some motherboard vendors have their own allocations 
>>> for ethernet
>>> addresses?
>>
>> We can teach it two ranges. I doubt anyone will be unlucky enough to 
>> have
>> the one which could be either Nvidia or Gigabyte and have it matter.
>>
>> The "go complain to the BIOS vendor" comment from Nvidia to me isn't an
>> answer. Maybe Nvidia can complain to BIOS vendors but end user 
>> complaints
>> of that form rarely have any effect.
>
> That wasn't the point of the response at all.  The datum is that set 
> of users where DEV_HAS_CORRECT_MACADDR is accurately set or clear is 
> vast majority of cases.
>
> For the rest, we'll want to look at adjusting DEV_HAS_CORRECT_MACADDR 
> based on DMI strings or a hueristic like you suggested.
>
>     Jeff
>
>
>

