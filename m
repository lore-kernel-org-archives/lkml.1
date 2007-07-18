Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbXGRXVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbXGRXVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbXGRXV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:21:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348AbXGRXVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:21:25 -0400
Date: Wed, 18 Jul 2007 16:20:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
In-Reply-To: <200707190053.24578.bzolnier@gmail.com>
Message-ID: <alpine.LFD.0.999.0707181618340.27353@woody.linux-foundation.org>
References: <469D1D5E.8050609@cateee.net> <alpine.LFD.0.999.0707181313100.27353@woody.linux-foundation.org>
 <20070718202740.GN11657@kernel.dk> <200707190053.24578.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> Thanks for finding and fixing this.
> 
> The latest patch (with additional cleanups) also looks good and should be
> safe enough (unchanged behavior for all non-pc requests) to merge it now.
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Ok, Jens - mind signing off on the patch you sent out, and writing an 
explanatory message? Feel free to just crib from my explanation of my 
original patch, or whatever.

And it would be beautiful if people who saw the bad behaviour before 
reverting the ide.c changes were to go back to that broken state, and try 
the patch, and just verify that it acts like it should (ie you should see 
just a few error messages, and it shouldn't cause the IDE layer to go 
ballistic any more).

		Linus
