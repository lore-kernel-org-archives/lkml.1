Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbXEYNeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbXEYNeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXEYNeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:34:06 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:37611 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbXEYNeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:34:05 -0400
Subject: Re: [RFC] LZO de/compression support - take 4
From: Richard Purdie <richard@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Andrey Panin <pazke@donpac.ru>,
       Bret Towe <magnade@gmail.com>, Michael-Luke Jones <mlj28@cam.ac.uk>
In-Reply-To: <4cefeab80705250557w1baee0afn255e37436b6545a@mail.gmail.com>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <1180095000.5864.48.camel@localhost.localdomain>
	 <4cefeab80705250557w1baee0afn255e37436b6545a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 May 2007 14:33:43 +0100
Message-Id: <1180100024.5864.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Fri, 2007-05-25 at 18:27 +0530, Nitin Gupta wrote:
> On 5/25/07, Richard Purdie <richard@openedhand.com> wrote:
> > On Fri, 2007-05-25 at 17:15 +0530, Nitin Gupta wrote:
> > > Richard, can you please provide perf. results for this patch also?
> > > Also, can you please mail back latest version of your LZO patch? In
> > > meantime, I will try to include benchmarking support to the
> > > 'compress-test' module.
> >
> > This version is 15% slower at decompression and about equal on
> > compression.
> 
> If you don't mind, can you please try patch attached now? I have now
> also rolled back that cpu_to_le16() change as Satyam suggested. I see
> no other reason for this perf. loss as I made no other change!

I tested it with no real change in the results. Since I'm doing the
tests on LE, cpu_to_le16() should a NOP anyway.

> Also, can you please verify if you are comparing your _safe_ version
> with this patch? This patch does not include unsafe version and the
> safe one is simply called lzo1x_decompress().

Yes, I am comparing with my safe version.

Cheers,

Richard

