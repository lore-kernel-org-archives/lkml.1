Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYEOXSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYEOXSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYEOXS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:18:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22440 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYEOXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AR1nkcqkf6ZpVxqrjH2Gp1/7Pu5lxHT4K/kJ4s/6mTPhItYbSVxzoKHcU7z3NkvpFeOBjKkRGe/pLCmHoO+MKVTm26cs2i9mjx98Jo5vkj0r4aCOGGPPJQzOYsEUPYfx9XYaP9QNcbW87ZHZbqT4XVCecUbeM0TMK5+fiTM7y1s=
Message-ID: <21d7e9970805151618i71ccc581j7e07082bd0b7a8e@mail.gmail.com>
Date: Fri, 16 May 2008 09:18:26 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: Weird Xorg radeon mirroring with linux-next-20080515 [paritial bisect]
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <g0iadj$dip$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <g0hflu$b4q$1@ger.gmane.org> <482C744C.3050308@redhat.com>
	 <g0iadj$dip$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hi,
>>>
>>> When using the radeon xorg driver with linux-next-20080515 there is a
>>> strange mirroring/stretching effect in the bottom eighth of the screen.
>>> The problem seems to have started sometime between linux-next-20080513
>>> and linux-next-20080515.
>>>
>>> (Do you always have to have done bisection before reporting
>>> regressions?)
>>>
>>>
>> NO!
>
> Ah, now you tell me : ) It sounded like bisection was what you did if you
> weren't a regular dev and you wanted your bug to get attention. I've
> spent a while trying to bisect this but didn't get all the way. My tests
> make me believe it lies somewhere between commits
> f5fbb15f66bd0a6017e4ca513217e823395502b7 and
> 6a305693b777ecd710107387a9753117a54bcbf9 ...
>
> The problem doesn't manifest directly after Xorg is started after boot -
> it seems to happen a few seconds later while services are still being
> started. Switching to a VT and back can make the problem go away.
>

wierd got any fglrx or anything installed on you're system.. the
radeon drm hasn't seen any changes that should affect this sorta
thing, do you run radeonfb or vesafb?

Dave.
