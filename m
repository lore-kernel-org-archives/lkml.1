Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZERNSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZERNSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZERNSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:18:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59979 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZERNSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vJqeqW7DdC+GHY1AWndVn++XBJwrs4Vk7nqXuIjEedmUOMW/bWvURAGBGTzhvFpDAV
         lBZKi9AtFo7NIfg+xJBHGUB8NpTNqLQEn0GFphOhz2NL9mlXwoOTkOJX6EzM71jCkKq5
         Jeunb7qtU4tgL17x/y3cU5dqdLk7c5hogh4bw=
MIME-Version: 1.0
In-Reply-To: <20090518063007.GA7818@liondog.tnic>
References: <20090509161801.GB5749@liondog.tnic>
	 <200905180532.n4I5Wxa1031243@turbo.physics.adelaide.edu.au>
	 <20090518063007.GA7818@liondog.tnic>
Date: Mon, 18 May 2009 15:18:13 +0200
Message-ID: <9ea470500905180618t3785d5e1s880c395896b9ba15@mail.gmail.com>
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
From: Borislav Petkov <petkovbb@googlemail.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small correction:

>> > > Should I just push commit 1e75540ec5202cae63cd238c86bd880e3d496546
>> > > ("ide-tape: remove back-to-back REQUEST_SENSE detection") to Linus
>> > > or there is more needed to bring ide-tape to the world of living?
>> >
>> > The oops will probably fixed the above commit.  I don't have much idea
>> > about the DMA problem on 2.6.24 tho.  But even with the above commit
>> > fixed, I doubt it would work.  The buffer allocation code is broken
>> > and reliably triggered OOM on my test machine.  While trying to locate
>> > the bug, I realized the complex code didn't do much good to begin with
>> > and just stripped it down, so I didn't actually tracked down the
>> > actual bug && the patch to simplify buffer management is way too large
>> > for 2.6.29, so unless someone is willing to hunt down the bug just for
>> > 2.6.29, we're kind of stuck.  :-(
>>
>> So I take it that 2.6.30 (or one of the RCs) is worth trying (at least in so
>> far as preventing the oops on boot)?
>
> You could try 30-rc6 which runs pretty stable on my machines. It has the
> patch mentioned above in it.

the patch mentioned above got actually merged after 30-rc6 so you could try
30-rc7 - if there will be one - or a current linux-next release.

Thanks.

-- 
Regards/Gruss,
Boris
