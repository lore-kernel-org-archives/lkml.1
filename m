Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYEEIhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYEEIhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYEEIhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:37:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:62897 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYEEIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HGawlwqD+0OS2Wr+PRfHKfSlMoyyITP09rEX0ndrm7mvvhRMXNIMOe2+xc1kzDxszBH7hiNT+AAoassJvaZRffFqwYbHYCJI1Pb0zWF8TJ3+MAfi9rNuWBhlgGIE+Tmzh5To5Qfi7Q9KUlU/2YSB4qPIgC+fNIeR68anT4ZdOq4=
Message-ID: <44c63dc40805050137g372bec5cr6d02eaf35b945629@mail.gmail.com>
Date: Mon, 5 May 2008 17:37:10 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 3/5] change function prototype of shrink_zone()
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <2f11576a0805050131k6df2c0d6r93edb4893ad655b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215718.8F5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40805042142k2e5bc366mffa9e0a22fbe94c9@mail.gmail.com>
	 <2f11576a0805050131k6df2c0d6r93edb4893ad655b9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I see
I seemed to be in a hurry without looking over following patches.

On Mon, May 5, 2008 at 5:31 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
> >  >  +       sc->nr_reclaimed += nr_reclaimed;
> >  >         throttle_vm_writeout(sc->gfp_mask);
> >  >  -       return nr_reclaimed;
> >  >  +       return 0;
> >  >   }
> >
> >  I am not sure this is right.
> >  I might be wrong if this patch is depended on another patch.
> >
> >  As I see, shrink_zone always return 0 in your patch.
>
> Yeah, this patch is just preparetion change of [4/5].
> I use EAGAIN at [4/5].
>
>
> >  If it is right, I think that return value is useless. It is better
> >  that we change function return type to "void"
> >  Also, we have to change functions that call shrink_zone properly. ex)
> >  balance_pgdat, __zone_reclaim
> >  That functions still use number of shrink_zone's reclaim page
>
> this patch is not intent by solo usage.
> just intent to bisect friendly.
> thus, We need implement that following patch use freature only.
>
> Thanks!
>



-- 
Thanks,
barrios
