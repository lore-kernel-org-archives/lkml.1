Return-Path: <linux-kernel-owner+w=401wt.eu-S932941Ab0AGEEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0AGEEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341Ab0AGEEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:04:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60871 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab0AGEEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:04:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kWfZLhIHp+LE50iB8Yyp1eu+ceHrL7b393gQZ4a0iAdVTse+8RjqLRVB1NqOsFka9O
         fc4foH+lMOXOTWeXWrGJHCpqtF1WvN/eiUgolMbdAvPTMr16bYqiSA3EjPhX9sOdFH1c
         TkRvl1/JxHAOZ3UIL5qGIrGG8ZO4B4GcYCpVQ=
MIME-Version: 1.0
In-Reply-To: <51f3faa71001061553q29e0821evda63c4ca3eeee3b1@mail.gmail.com>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> 
	<4B43DF97.7080208@gmail.com> <20100106083214.DAAA933C5F5@tippex.mynet.homeunix.org> 
	<51f3faa71001061553q29e0821evda63c4ca3eeee3b1@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 6 Jan 2010 23:04:16 -0500
Message-ID: <3e8340491001062004h302912a5h8ac441f9fe629af6@mail.gmail.com>
Subject: Re: Memory probing fails after 2.6.30 (bisected)
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Anders Eriksson <aeriksson@fastmail.fm>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 6:53 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Wed, Jan 6, 2010 at 2:32 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>>
>> hancockrwd@gmail.com said:
>>> Think you missed posting which was the actual bad commit it reported?
>>
>> The last one in the list:
>> 8ecee4620e76aae418bfa0e8cc830e92cb559bbb
>>
>> That's a merge commit. How do i dig futher into that? My git-fu is lacking...
>
> AFAIK, the bisect shouldn't land on a merge commit unless the changes
> in the commit itself are what are causing the problem, and the merge
> commit itself doesn't have any changes. Is it possible something went
> wrong in the bisect and one of your good/bad results was incorrect?

It's also possible for the bisect to land on a merge if each parent of
the merge works, but combining them leads to an interaction causing
the bug. I'd suggest specifically retesting each of the parents of the
merge, and the merge itself.
