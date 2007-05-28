Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXE1JJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXE1JJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXE1JI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:08:56 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:5567 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbXE1JIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oHXUfEL92EQm2my+hDTQyrnxEhsdRfLxaXtbNlRMGMFC/kax0B0akhR7pkFu3U44b64A8Rlixv22bJaHihL63obKxz8GyQKCWChfJK5elONboBv9Xy7v3kdvNyM5K5NWLgf0xeUYVah4R7sn45BoqOsLxOG896YwSeSlaqnowRM=
Message-ID: <4cefeab80705280208v2cfdd420u82f1d3b157abb6e0@mail.gmail.com>
Date: Mon, 28 May 2007 14:38:54 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: [RFC] LZO de/compression support - take 4
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Richard Purdie" <richard@openedhand.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
In-Reply-To: <200705280443.56152.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <200705280418.07538.dhazelton@enter.net>
	 <4cefeab80705280137v178a449fl391b99b6804a75f2@mail.gmail.com>
	 <200705280443.56152.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> On Monday 28 May 2007 04:37:04 Nitin Gupta wrote:
> > On 5/28/07, Daniel Hazelton <dhazelton@enter.net> wrote:

<snip>

> >
> > As you mentioned in your mail, you are using lzo1x_1_11_compress()
> > which is slower than what I ported (which is same as what is exported
> > by miniLZO). So, can you please test with the version ported  - this
> > is found in lzo/src/lzo1x_1.c (or in minilzo.c).
> > Also, can you please use 'take 5' for your next testing?
> >
> > Thanks,
> > Nitin
>
> Will do.  (that's DBITS=15, correct?)
>

That's D_BITS=14

> However, when I averaged it 100 times, lzo1x_1_11_compress() showed better
> speed than your implementation - about 1.5% faster.

I don't yet have any explanation for this.

> The *unsafe*
> decompressor, however, only shows about a 1.2% speed advantage over the safe
> decompressor.
>
> DRH
>
