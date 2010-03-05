Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0CEOeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:34:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:63229 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0CEOeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:34:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fntfIlZnMNXtWKc//+Jkiq4NA51RPMjln4CHWh/KO8RtpZrxEofyTEiYUj4o0jk5GK
         n2Cu3kT8RraOu0z3MbW+mkJcPqxuhO3Vqq7wCjznQiS20ovHjO6zA+Ogk2us07PcEOlF
         N/jEMx56uyixq0hIGMFYh8SL6Zn3SJCuzP624=
MIME-Version: 1.0
In-Reply-To: <4B90E415.5090106@asladvancedsys.in>
References: <4B868701.3010904@asladvancedsys.in>
	 <3efb10971003050229na0fd4fbl128a890b0cf245c0@mail.gmail.com>
	 <4B90E415.5090106@asladvancedsys.in>
Date: Fri, 5 Mar 2010 15:34:06 +0100
X-Google-Sender-Auth: 8861d6289d5b2828
Message-ID: <3efb10971003050634o37807a22tccd5c9416f3eb7a@mail.gmail.com>
Subject: Re: Info on AT91 patches against mainline kernel
From: Remy Bohmer <linux@bohmer.net>
To: Ravi Kumar Kulkarni <ravikulkarni@asladvancedsys.in>
Cc: linux-kernel@vger.kernel.org, linux@maxim.org.za
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/3/5 Ravi Kumar Kulkarni <ravikulkarni@asladvancedsys.in>:
> Hi Remy,
>>
>> You do not necessarily need the at91-patchset from Andrew.
>> 2.6.33 works fine on at91sam9261 without it...
>>
>> Remy
>>
>
> Thanks for the info. I will try to compile 2.6.33  now. But i got a mail
> from andrew  that he updated at91 patchset to 2.6.32 . for clarification jus
> verifying tat u mean  from 2.6.33 onwards  u  don't need at91 patches and
> can directly compile without waiting Andrew's patchset . If tats case then
> Andrew can update that in linux4samdotorg website so that it will be helpful

You only need the changes from Andrew in case there is something in
there that you require, you should look at the changelog to be sure.
But, the at91sam9261 is already for several years in mainline and it
works fine (even much older kernels than 2.6.33 will work without it,
for example we used 2.6.24, 2.6.26, 2.6.31 without it), Andrews
patchset is just a set of additional changes that will likely be
pushed to mainline at some time.

Remy
