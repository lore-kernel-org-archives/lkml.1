Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXE1JrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXE1JrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbXE1JrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:47:01 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:32443 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbXE1JrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XFB/LSS8Qmbrwp7n7SZrPp5gxFYg5ZIAhZ1LBQT61U67OeWYgw6uX5Orgy60ntsDFKUiiiDiWPS0cbIuo+sRqefc9RIZaBumviKa2YsFmkN3TNqGLiaJQHBSbqD6p48Y6kf6fOaao1Y2kqtqEWTjq0X0TMRZTVrxN57207gal3U=
Message-ID: <4cefeab80705280246i7c0a3d43j90f6dddf197bb9b5@mail.gmail.com>
Date: Mon, 28 May 2007 15:16:59 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: [RFC] LZO de/compression support - take 4
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Richard Purdie" <richard@openedhand.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
In-Reply-To: <200705280521.16795.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <200705280443.56152.dhazelton@enter.net>
	 <4cefeab80705280208v2cfdd420u82f1d3b157abb6e0@mail.gmail.com>
	 <200705280521.16795.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> On Monday 28 May 2007 05:08:54 Nitin Gupta wrote:
> > On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> > > On Monday 28 May 2007 04:37:04 Nitin Gupta wrote:
> > > > On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
>
> New testbed based on minilzo complete.
> Results from run using 1000 runs to generate averages:
> 1000 run averages:
> 'Tiny LZO':
>         Combined: 55.196 usec
>         Compression: 37.132 usec
>         Decompression: 18.064 usec
> 'miniLZO':
>         Combined: 55.785 usec
>         Compression: 40.862 usec
>         Decompression: 14.923 usec
>

Great!

I believe its now ready for mainline. We can do further cleanups and
optimizations there - more users of this code will surely drive more
enhancements.

> (using (tiny/full)/100 for percentages:
> 'Tiny' is 0.9% faster on average


I think this is more appropriate: [(full-tiny)/full]*100
=> tiny is ~1% faster on average.


> Same for the Compression
> 'safe' decompressor from tiny is 1.2% slower than unsafe from minilzo)
>

This is expected :)


Cheers,
Nitin
