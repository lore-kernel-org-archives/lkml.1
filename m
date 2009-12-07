Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZLGOlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZLGOlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbZLGOlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:41:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43980 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbZLGOlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:41:44 -0500
Date: Mon, 7 Dec 2009 15:41:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was
	delayed
Message-ID: <20091207144149.GZ8742@kernel.dk>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com> <4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com> <4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com> <20091206104950.GN8742@kernel.dk> <x49iqciyis3.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iqciyis3.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Sun, Dec 06 2009, Corrado Zoccolo wrote:
> >> Hi Jeff,
> >> I remember you saw large performance drop on your SAN for sequential
> >> writes with low_latency=1.  Can you test if Shaohua's and this patch
> >> fix allow to recover some bandwidth?  I think that enabling the queue
> >> depth ramp up only if a sync request was delayed should disable it for
> >> fast hardware like yours, so you should not be seeing the slowdown any
> >> more.
> >
> > I queued this up for post inclusion into 2.6.33, with the time_after()
> > fixed.
> >
> > The patch was word-wrapped, btw.
> 
> So in what branch can I find this fix?  Once I know that I can queue up
> some tests.

It's in next-2.6.33

-- 
Jens Axboe

