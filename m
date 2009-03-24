Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbZCXPvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbZCXPvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZCXPvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:51:00 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34949 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZCXPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RYEbWAlIuRVqAjPtdoLGXsjh+SBlRB2/z2h5ghPWqdgXJhI87B5WVqex4rOxH3mYqw
         n7/NTTk0tsRYHfG0KEtaTrKqEdVOO+3qz6qBrdfS0LSOqyJ85k2MIaChoCR4p+m7AUnk
         8niHIJvN7f6GOWcEhKRFppPC6hRIg9RbqHoso=
MIME-Version: 1.0
In-Reply-To: <a4423d670903240846j252a825cy1e8a50b5ac3a11ef@mail.gmail.com>
References: <a4423d670903180958j4847717eh99a41534633dd314@mail.gmail.com>
	 <20090318.234451.38898787.davem@davemloft.net>
	 <a4423d670903190116p157b2ebfl69d270e0576c6d9a@mail.gmail.com>
	 <20090322.215110.261185328.davem@davemloft.net>
	 <a4423d670903240432m1a4e8e08x9c97a0947d89800a@mail.gmail.com>
	 <a4423d670903240846j252a825cy1e8a50b5ac3a11ef@mail.gmail.com>
Date: Tue, 24 Mar 2009 18:50:55 +0300
Message-ID: <a4423d670903240850w223cdb74k7165ffd70cd7b357@mail.gmail.com>
Subject: Re: next-20090318: sunhme does not transmit packets
From: Alexander Beregalov <a.beregalov@gmail.com>
To: David Miller <davem@davemloft.net>, Roel Kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-next@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/24 Alexander Beregalov <a.beregalov@gmail.com>:
> 2009/3/24 Alexander Beregalov <a.beregalov@gmail.com>:
>>>> 2009/3/19 David Miller <davem@davemloft.net>:
>>>> > Does the current vanilla kernel work fine?
>>>>
>>>> Yes. The problem happens only with -next tree.
>>>
>>> I have one of my ultra10s up and will try to reproduce and diagnose
>>> this locally.
>>
>> Hi David
>>
>> 2.6.29 also does not work.
>>
>> The guilty patch should be between 2.6.29-rc8 and final 2.6.29
>>
>> even more narrow - 59fcbdd..v2.6.29
>>
>> I can try to bisect.
>
> e4a389a9b5c892446b5de2038bdc0cca8703c615 is first bad commit

No, it is wrong, sorry.
I will do more tests tomorrow.
