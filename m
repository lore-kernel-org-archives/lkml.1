Return-Path: <linux-kernel-owner+w=401wt.eu-S1761553AbYCDJ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbYCDJ6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYCDJ5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:57:55 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52165 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbYCDJ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:57:54 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: -rc3 regression (was Re: 2.6.25-rc2 + smartd = hang ) 
In-reply-to: <200803040133.07736.bzolnier@gmail.com> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <20080228143854.6350093C855@tippex.mynet.homeunix.org> <200803040116.42764.bzolnier@gmail.com> <200803040133.07736.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Tue, 04 Mar 2008 01:33:07 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 04 Mar 2008 10:57:01 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080304095701.DDF762DC027@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JWTuA-0006Rg-3W.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JWTuA-0006Rg-3W 9f292c6d75e4fe7109816e5775ebe88f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



bzolnier@gmail.com said:
>> On Tuesday 04 March 2008, Bartlomiej Zolnierkiewicz wrote:
>> Untested patch which may help in case that set_pio_mode() raced with
>> the queueing of the special request and block layer doesn't call
>> ->request_fn_proc again if we were preempted previously (if PREEMPT=y).

> I need some sleep...  this patch is not going to help (though disabling
> PREEMPT may be worth a try).  Sorry for the confusion.

Ok, I'll drop the patch and, recompile without PREEMPT.


bzolnier@gmail.com said:
> If the patch doesn't help could you try removing smartd from system startup
> and see if it could be run later from the command line? 

That's how I executed during the bisect. It works as a charm without smartd. 
The moment I run it, boink, the first accessed hd freezed up. The other ones 
are usable for a while, though the system tend to lock solid after a while.

/A 




