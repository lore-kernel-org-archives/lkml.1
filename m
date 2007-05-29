Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbXE2MEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbXE2MEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXE2MD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:03:57 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:25571 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbXE2MD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D74IGbccuOUxria+WgbpKWwjqzcha7e5mrmlc2j7SxAxbqPmiHgDaQFxZWB0Zl9TdO9N25TIKnZXu7zXLNj1+mi2G6Ld5mxR8uhs7dlkHiRL02nptRIobIs98/+vHY+B7ygKzwZDnIFC2KXK7Sld6P0AVj2Pa55CVCdPsIhwG9I=
Message-ID: <4cefeab80705290503k70572e9bmc76e466c7967871b@mail.gmail.com>
Date: Tue, 29 May 2007 17:33:55 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>
In-Reply-To: <20070529114043.GR3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
	 <200705281049.48679.dhazelton@enter.net>
	 <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
	 <20070528171115.GQ3899@stusta.de>
	 <7A4314A3-24D8-49E2-BEEF-D760595255A2@cam.ac.uk>
	 <20070529114043.GR3899@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Tue, May 29, 2007 at 09:08:27AM +0100, Michael-Luke Jones wrote:
> > On 28 May 2007, at 18:11, Adrian Bunk wrote:
> >
> >> I have not seen any explanations:
> >> - Why did the upstream author write the code that way?
> >
> > Apparently due to his requirement for extreme portability. The original
> > code was designed to work on everything from 16-bit DOS through CRAY
> > supercomputers through Windows, Unices and Linux.
>
> Sure, this could be the reason in some or all cases.
>
> The upstream author knows the code best, and discussing such issues with
> him will in many cases be a win:
>
> It could be that there was in some cases no good reason, and the
> upstream code that gets used by many other projects could become faster.
>
> Or there was a good reason that applies also to the in-kernel version
> and a change breaks some corner case.
>

I have mailed the author with detailed changelog - waiting for reply.

> > The author has stated on the thread that it's a good idea to remove
> > unnecessary ifdefs when porting the code into the kernel, given that the
> > portability requirements are obviously no longer needed.
>
> "remove unnecessary ifdefs" implies "generated code is identical".
>
> That's quite different from "code is 10% faster".
>

Daniel made some changes to his testing code and now the perf gain is just 1.6%.

- Nitin
