Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZAJTos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZAJTos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 14:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZAJTok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 14:44:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:17885 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZAJToj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 14:44:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vHhllnJDyQNbU4LtgfgUX+Sim0eRfuqCYdf/LEgdCRicrcdl+KdHf66mb4nmGF/HGJ
         K792urBI1u+g7c4ZjppnpiQkH+odJPFko8CR0AQGnQDsFO3S116W9uwelJ3tGhv4uwJv
         iQvX+HPjijArmHcfp42dTHZXpGEIm7C4W9G/Q=
Message-ID: <2f11576a0901101144y66c072e9w5da6bde9d000e907@mail.gmail.com>
Date: Sun, 11 Jan 2009 04:44:38 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: kobayashi.kk@ncos.nec.co.jp
Subject: Re: [PATCH 2/3 v2] proc: Export statistics for softirq to /proc
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       h-shimamoto@ct.jp.nec.com
In-Reply-To: <51c5bc110901101022g1fc407f6ifc37aa93580a2da1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp>
	 <20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
	 <20081126190603.3CC3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090109141642.61540741.akpm@linux-foundation.org>
	 <51c5bc110901101022g1fc407f6ifc37aa93580a2da1@mail.gmail.com>
X-Google-Sender-Auth: 873ab6371c8390d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> You can calcurate per_irq_sum here.
>>> Typically, # of possible cpu are very big.
>>>
>>> So, I don't like unnecessary twrice looping.
>>
>> I was about to send these patches to Linus, but it seems that this
>> optmisation hasn't been addressed?
>
> Thanks for your notice, Andrew.
> Of course, thanks for your advice, Kosaki-san.
> I didn't check carefully about this point...
>
> Now I am on a business trip.
> So, I'll post the fix next week.

No problem.
I've made it three hour ago. I'll post soon.
