Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYGUQEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYGUQEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYGUQEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:04:45 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:4011 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYGUQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fv6K45cTT+UtK3sMI53mHRpqMfzAt5VXEVtgsU0Hy4E7kfiMqRH+J3w1pHRsljy2F8
         NTROdO9M6JbDsaYt1cZH9KMm0mMYxHmhsviro7cDuh/SiSJvLOHbafNIHYkvY2mNdG2e
         zzlyGuyCJKAyPwNMpauT3rB6J5ooSkG6w41ig=
Message-ID: <a4423d670807210904je651e16md5aa61c734de9bdd@mail.gmail.com>
Date: Mon, 21 Jul 2008 20:04:43 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [GIT]: Networking
Cc: bhutchings@solarflare.com, adobriyan@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jeffrey.t.kirsher@intel.com
In-Reply-To: <20080721.083527.199623566.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080720.221106.201055562.davem@davemloft.net>
	 <a4423d670807210248l1e2e6999ha462edc99002f964@mail.gmail.com>
	 <20080721101626.GM10471@solarflare.com>
	 <20080721.083527.199623566.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/21 David Miller <davem@davemloft.net>:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Mon, 21 Jul 2008 11:16:27 +0100
>
>> Alexander Beregalov wrote:
>> > Hi David!
>> >
>> > There is another problem on sparc64 and happymeal ethernet card.
>> >
>> > when tring to up interface:
>> >
>> > kernel BUG at net/core/dev.c:1328
>> [...]
>>
>> This is yet another driver calling netif_wake_queue() during dev_open(),
>> when there is no real qdisc present.  (And yes, sfc is another of those
>> drivers - I will post a patch after internal review.)
>
> Yep, what idiot wrote this driver? ;-)
>
> Alexander please try this patch:
It works, thanks.
