Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbXETGa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbXETGa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbXETGaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:30:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:30686 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbXETGaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UXT3BO37oTVknsIh+13+QqpCHmFj/xFu9RestglV1MMQi7nfPnFKFMj7Jp2Xny0AhiX40BNG4QbyVc/s3wX9eNQO0N50fAkp6PHzUDuZ8x5BLIM1f7/iX3THRF7HGdU0vLmQw/HmjA43MUTVg1vWXOAeJzx0RcegqkZ3pGraP98=
Message-ID: <2c0942db0705192330r4004d7bem3556c939c1581553@mail.gmail.com>
Date: Sat, 19 May 2007 23:30:17 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Gerdau" <mgd@technosis.de>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705200812.26391.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F57DD.2000309@tmr.com>
	 <2c0942db0705191322p54e05e40p512146f21f68299a@mail.gmail.com>
	 <464F99EC.3080006@tmr.com> <200705200812.26391.mgd@technosis.de>
X-Google-Sender-Auth: 0e80847f57af4530
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Michael Gerdau <mgd@technosis.de> wrote:
> > Okay, here's a bonus, http://www.tmr.com/~davidsen/sched_smooth_02.html
> > not only has the right values, the labels are changed, and I included
> > more data points from the fc6 recent kernel and the 2.6.21.1 kernel with
> > the mainline scheduler.
> >
> > The nice thing about this test and the IPC test I posted recently is
> > that they are reasonable stable on the same hardware, so even if someone
> > argues about what they show, they show the same thing each time and can
> > therefore be used to compare changes.
>
> I'm not sure I follow you here. The difference between 2.6.21 and 2.6.21.1
> are two simple (as in involving little code) changes to ip4 and ip6 net
> and I'm not even sure that code is used at all in your tests.
> [Read: IMO the 2.6.21 and 2.6.21.1 figures are for identical cases].
>
> Assuming the above is correct then IMO the variance between the two
> "dublicated" lines (cfs-v13 and sd048) is such that I would not have
> written "that they are reasonable stable on the same hardware".
>
> I don't want to say the values aren't useful. I simply think there is
> a high noiselevel.

The noise is reflected in the standard deviation he has on those rows.
The average +- stdev  of one overlaps the average +- stdev of the
other, which shows that the test *is* stable, where stable (as always)
is defined to some accuracy.
