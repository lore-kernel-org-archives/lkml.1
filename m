Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbXE1TvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbXE1TvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXE1TvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:51:11 -0400
Received: from keil-draco.com ([216.193.185.50]:50528 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751460AbXE1TvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:51:10 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Date: Mon, 28 May 2007 15:51:05 -0400
User-Agent: KMail/1.9.6
Cc: Nitin Gupta <nitingupta910@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <200705281155.14466.dhazelton@enter.net> <20070528170109.GP3899@stusta.de>
In-Reply-To: <20070528170109.GP3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281551.05506.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 13:01:09 Adrian Bunk wrote:
> On Mon, May 28, 2007 at 11:55:14AM -0400, Daniel Hazelton wrote:
> >...
> > This is my guess as well. Though performance will likely drop when I make
> > the noinline macro mean something. (This may be offset by figuring out a
> > way to make likely() and unlikely() also have a meaningful effect in
> > userspace). ...
>
> What is your problem?
>
> The likely/unlikely macros aren't in any way depending on any kernel
> infrastructure.

That I'm just plain lazy and haven't felt like pulling them out of the kernel 
sources ?

Actually, that is the case - and I wasn't exactly sure that likely() and 
unlikely() were completely decoupled from the kernel's infrastructure.

DRH

> > DRH
>
> cu
> Adrian


