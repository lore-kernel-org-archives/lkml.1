Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbYBTJtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbYBTJtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYBTJtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:49:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:21261 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbYBTJtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uZQFotw9tKYRpjawvCxtyr1jiepcl1HSfJ2m3cBTW7b6GGWneOn30oB5RExgqAsv/Ze20hEcgG7RVvGeLaIpGHtiw89NftgiMmbM5ES+SQeXkNdiK3QBvtZwPrPO1He1WKq/FkzbRN1s+HcmYiuOYxnoN1R0Possi/k7B5mE6P8=
Message-ID: <44c63dc40802200149r6b03d970g2fbde74b85ad5443@mail.gmail.com>
Date: Wed, 20 Feb 2008 18:49:03 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080220181447.6444.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40802200056va847417v1cfc847341bb8cc0@mail.gmail.com>
	 <20080220181447.6444.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 20, 2008 6:24 PM, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi Kim-san
>
> Do you adjust hackbench parameter?
> my parameter adjust my test machine(8GB mem),
> if unchanged, maybe doesn't works it because lack memory.

I already adjusted it. :-)
But, In my desktop, I couldn't make to consune my swap device above
half. (My swap device is 512M size)
Because my kernel almost was hang before happening many swapping.
Perhaps, it might be a not hang.  However, Although I wait a very long
time, My box don't have a any response.
I will try do it more.

> > I am a many interested in your patch. so I want to test it with exact
> > same method as you did.
> > I will test it in embedded environment(ARM 920T, 32M ram) and my
> > desktop machine.(Core2Duo 2.2G, 2G ram)
>
> Hm
> I don't have embedded test machine.
> but I can desktop.
> I will test it about weekend.
> if you don't mind, could you please send me .config file
> and tell me your test kernel version?

I mean I will test your patch by myself.
Because I already have a embedded board and Desktop.

> Thanks, interesting report.
>
>
> > I guess this patch won't be efficient in embedded environment.
> > Since many embedded board just have one processor and don't have any
> > swap device.
>
> reclaim conflict rarely happened on UP.
> thus, my patch expect no improvement.

I agree with you.

> but (of course) I will fix regression.

I didn't say your patch had a regression.
What I mean is just that I am concern about it.
Actually, Many VM guys is working on server environment.
They didn't try to do performance test in embedde system.
and that patch was submitted in mainline.

Actually, I am concern about it.

> > So, How do I evaluate following field as you did ?
> >
> >  * elapse (what do you mean it ??)
> >  * major fault
>
> /usr/bin/time command output that.
>
>
> >  * max parallel reclaim tasks:
> >  *  max consumption time of
> >         try_to_free_pages():
>
> sorry, I inserted debug code to my patch at that time.
>

Could you send me that debug code ?
If you will send it to me, I will test it my environment (ARM-920T, Core2Duo).
And I will report test result.

-- 
Thanks,
barrios
