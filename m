Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYENAgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYENAgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYENAgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:36:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38606 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbYENAgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:36:06 -0400
Subject: Re: performance "regression" in cfq compared to anticipatory, 
	deadline and noop
From: Kasper Sandberg <lkml@metanurb.dk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matthew <jackdachef@gmail.com>
In-Reply-To: <1210686664.1093.33.camel@localhost>
References: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com>
	 <1210514567.7827.62.camel@localhost>  <20080513122021.GP16217@kernel.dk>
	 <1210686664.1093.33.camel@localhost>
Content-Type: text/plain
Date: Wed, 14 May 2008 02:33:03 +0200
Message-Id: <1210725183.1093.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 15:51 +0200, Kasper Sandberg wrote:
> On Tue, 2008-05-13 at 14:20 +0200, Jens Axboe wrote:
> > On Sun, May 11 2008, Kasper Sandberg wrote:
> > > On Sun, 2008-05-11 at 14:14 +0100, Daniel J Blueman wrote:
> > > > I've been experiencing this for a while also; an almost 50% regression
> > > > is seen for single-process reads (ie sync) if slice_idle is 1ms or
> > > > more (eg default of 8) [1], which seems phenomenal.
> <snip>
> > > 
<snip>
> 
> i expect to get around to doing this this afternoon, or tonight at
> ~02:00
> (im GMT+1).

Well :) not too far off(02:32 now)

http://62.242.235.92/~redeeman/blktrace.tar.bz2

it contains the blktrace with cfq, noop, anticipatory and deadline,
along with the output of blktrace and hdparm.

Hope it helps.

> 
> 
> > 
> > If someone would send me a blktrace of such a slow run, that would be
> > nice. Basically just do a blktrace /dev/sda (or whatever device) while
> > doing the hdparm, preferably storing output files on a difference
> > device. Then send the raw sda.blktrace.* files to me. Thanks!
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

