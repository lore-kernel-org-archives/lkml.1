Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXEZUnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXEZUnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764063AbXEZUnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:43:39 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:11427 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552AbXEZUni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V6Q05SF8OhBFzYXkhWTtzb0LMxUeWO1UzpLCvL/9iPV6n3BXX+XkJ7DIQz9mYyDvmHUHcclvJ0tnl/vZmVPMngxN8rGf8aMZAH3QgwLNfTQImgB02SwjAInbGmMVqcwsV3rXTNURzaklOpQ7m3IAqtRVQelXvZ+JpkcGpA5Air0=
Message-ID: <f56c1ba00705261343u597b1a7am6fdccbab840a4093@mail.gmail.com>
Date: Sat, 26 May 2007 22:43:34 +0200
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: 2.6.21-mm2: HDAPS? BUG: at kernel/mutex.c:311
Cc: "Dmitry Torokhov" <dtor@insightbb.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, rlove@rlove.org,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <a781481a0705132040u1c4047f0xf953ccd13f622684@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070512002115.GZ11166@waste.org>
	 <200705120112.52859.dtor@insightbb.com>
	 <a781481a0705112245u356759dcm9a550e432ed178fd@mail.gmail.com>
	 <200705132257.07257.dtor@insightbb.com>
	 <a781481a0705132040u1c4047f0xf953ccd13f622684@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/14, Satyam Sharma <satyam.sharma@gmail.com>:
> On 5/14/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > Hi Satyam,
> >
> > On Saturday 12 May 2007 01:45, Satyam Sharma wrote:
> > > Seems to be good-looking code!
> >
> > Thanks. Do you have the hardware? Were you able to test the patch?
>
> Oh, sorry, no. I was actually referring to the input-polldev code. Let's
> hope Matt can test and ack this.
>
> Thanks,
> Satyam
> -

Hi all,

Since i still had that BUG on my T43 running a 2.6.22-rc2-mm1 kernel,
I tried that patch. It sounds like this has solved the bug since I
can't find any trace of that issue anymore once the patch is applied.

Thanks for the patch,
Regards,
Cédric
