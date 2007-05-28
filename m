Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbXE1J6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbXE1J6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXE1J6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:58:40 -0400
Received: from keil-draco.com ([216.193.185.50]:50741 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750787AbXE1J6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:58:40 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Date: Mon, 28 May 2007 05:58:31 -0400
User-Agent: KMail/1.9.6
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Richard Purdie" <richard@openedhand.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com> <200705280521.16795.dhazelton@enter.net> <4cefeab80705280246i7c0a3d43j90f6dddf197bb9b5@mail.gmail.com>
In-Reply-To: <4cefeab80705280246i7c0a3d43j90f6dddf197bb9b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705280558.31582.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 05:46:59 Nitin Gupta wrote:
> On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Monday 28 May 2007 05:08:54 Nitin Gupta wrote:
> > > On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> > > > On Monday 28 May 2007 04:37:04 Nitin Gupta wrote:
> > > > > On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> >
> > New testbed based on minilzo complete.
> > Results from run using 1000 runs to generate averages:
> > 1000 run averages:
> > 'Tiny LZO':
> >         Combined: 55.196 usec
> >         Compression: 37.132 usec
> >         Decompression: 18.064 usec
> > 'miniLZO':
> >         Combined: 55.785 usec
> >         Compression: 40.862 usec
> >         Decompression: 14.923 usec
>
> Great!
>
> I believe its now ready for mainline. We can do further cleanups and
> optimizations there - more users of this code will surely drive more
> enhancements.

Forgot to mention - this is still 'take 4' - I'm going to import the 'take 5' 
code now and see if there is any appreciable difference
>
> > (using (tiny/full)/100 for percentages:
> > 'Tiny' is 0.9% faster on average
>
> I think this is more appropriate: [(full-tiny)/full]*100
> => tiny is ~1% faster on average.

Okay, I'll use that for all future calculation.

DRH

(Next version of the testbed will also test against the _safe variant in 
miniLZO)
