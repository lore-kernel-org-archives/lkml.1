Return-Path: <linux-kernel-owner+w=401wt.eu-S965743AbXCLL6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743AbXCLL6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965739AbXCLL6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:58:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:25971 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965743AbXCLL6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jHdPSUT9VVnQwWdcNW0Wy8yF3RxLdmRW2gUtqqqCuoSK+mnn5pgWveMTYqFEKT72IoFrglJ4Jky9BjfrdqQwHLt/n1lfvVB7HncZrH2tkTVk7mhwIJyS2x6rBtS5khjS5y18ynJW+yAeDxdDeQvmcaj+zqcMufbvv1Z66L9J+oU=
Message-ID: <8cd998d50703120458j6ac9f33h79728f2f599a3b91@mail.gmail.com>
Date: Mon, 12 Mar 2007 22:58:11 +1100
From: "Con Kolivas" <kernel@kolivas.org>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Cc: linux-kernel@vger.kernel.org,
       "Radoslaw Szkodzinski" <astralstorm@gmail.com>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200703120749.39303.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
	 <f44c5fdf0703112358j4f94998aq9e45b0a6e848551d@mail.gmail.com>
	 <200703120716.03519.gene.heskett@gmail.com>
	 <200703120749.39303.gene.heskett@gmail.com>
X-Google-Sender-Auth: ac85079c77962bf2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Monday 12 March 2007, Gene Heskett wrote:
> >To Con, I knew 2.6.20 worked with your earlier patches, so rather than
> >revert all the way, I just rebooted to 2.6.20.2-rdsl-0.30 and I'm going
> >to fire off another backup.  I suspect it will work, but will advise the
> >next time I wake up.
>
> After posting the above, I thought maybe I'd hit a target in the middle
> and build a 2.6.20.2, with your -0.30 patch, but...
>
> I'm going to have to build a 2.6.20.2, because with the rdsl-0.30 patch,
> its going to do a level 2 on my /usr/movies directory, which hasn't been
> touched in 90 days and has about 8.1GB in it according to du, and its
> going to do nearly all of it.  It shouldn't be anything but a directory
> listing file. But this is what amstatus is reporting:
> coyote:/usr/movies            2     7271m dumping      793m ( 10.91%)
> (7:26:00)
>
> And its also reporting far more data than exists it seems. As is du,
> for /var, which might have 2 gigs, its claiming 3.7!
>
> Honest folks, I'm not smoking anything, I quit 18 years ago.  Back to bed
> while this one bombs out too.
>
> --
> Cheers, Gene

Gene your last good kernel you said was 2.6.20 based. I don't see a
good reason even to use 2.6.20.2 as a base given that information.

--
-ck
