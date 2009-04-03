Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZDCCuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZDCCuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZDCCt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:49:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:12707 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZDCCt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=muY6pTWOG10Fs/siKKPX2ThVpQ4d1XngqvPauxX3Hqm1XIGdhzq0HY0ipiGscva8pM
         82mtbIViButzZmvjea7Duu8pGGaRWmfz+8LQVZ9ogmmJH3vdfVz5yRWSRC12m6QBObiA
         U+bn3hbuQPJEuRfRF5ooY1/hpgG7WmfucbRyc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0904021938560.6162@bogon.housecafe.de>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <20090403020525.GI9870@mit.edu>
	 <alpine.DEB.2.01.0904021938560.6162@bogon.housecafe.de>
Date: Thu, 2 Apr 2009 20:49:55 -0600
Message-ID: <9b1675090904021949g301b1bbaxd1810ce82185e002@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Theodore Tso <tytso@mit.edu>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 8:45 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Thu, 2 Apr 2009, Theodore Tso wrote:
>> It will, but you might not like the performance....  the reason why
>> it's there is that some users might want the particular tradeoff, but
>> it probably wouldn't make a good default.
>
> Thanks for confirming this. Yes, I know about the performance impact, but
> perhaps it's feasible for some setups.
>
> Christian.
>
> PS: I was curious *how* bad the impact was and so I tried generating a
>    477 MB tarball, first on an async, then on an sync mounted partition:
>
>   /dev/md0 /mnt/md0 ext4 rw,noatime,barrier=1,data=ordered
>   $ time tar -cf /mnt/md0/test.tar /usr
>   real 1m36.615s
>
>   /dev/md0 /mnt/md0 ext4 rw,sync,noatime,barrier=1,data=ordered
>   $ time tar -cf /mnt/md0/test.tar /usr
>   real 5m23.793s

lol, yep sounds about right.  Probably much worse on my machine, given
the disk speed is around 20-23M/sec.
