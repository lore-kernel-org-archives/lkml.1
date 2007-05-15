Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXEOPSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXEOPSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXEOPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:18:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:36720 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933AbXEOPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jIcAKQwNwC38m2cLUGTjMae4eYRyLBAvYbbSa9enSCmxEydKETGxMlWm934uHESMppMHafyqNA6USk7g3qDZvjv+MQobZ+CLKRVGtQSlyV1kAQw94pPrE7FbPckKDM8unB0QYtu/0eBrMm458JIxEcIu6fd393rz9ou+XCjxUnI=
Message-ID: <4d8e3fd30705150818g1755b441w536763d0902ca3cf@mail.gmail.com>
Date: Tue, 15 May 2007 17:18:12 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Brad Campbell" <brad@wasp.net.au>
Subject: Re: Standalone swap prefetch patch for mainline
Cc: "Con Kolivas" <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
In-Reply-To: <4649C789.6050305@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705141210.43614.kernel@kolivas.org>
	 <4649C789.6050305@wasp.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Brad Campbell <brad@wasp.net.au> wrote:
> Con Kolivas wrote:
> > I've had a few requests for a standalone patch implementing swap prefetch for
> > mainline.
> >
> > Here is a patch that is a current rollup that should apply and work for
> > vanilla 2.6.21 (ie not a -ck kernel):
> >
> > http://ck.kolivas.org/patches/swap-prefetch/2.6.21-swap_prefetch-38.patch
> >
>
> Heh.. 20 mins after I finished scraping the relevant bits from -ck1 and patching my kernel this arrives!
>
> <WARNING - Fanboy rant ahead>
>
> I don't normally get/take the time to pass personal comment, but I have to say Con I've just taken a
> 2.6.21 kernel, applied your 0.48 SD scheduler and swap-prefetch from -ck1 (needed to separate them
> out so I could also apply suspend2) and it's like I've bought a new machine.
>
> I'm running on a tiny Vaio with a 4800RPM 1.8" drive, so it's not fast by any stretch of the
> imagination. But the combination of SD and swap-prefetch has given it a new lease on life completely.
>
> Really, you have done a great job with SD. I was so impressed I built a new kernel for my Core Duo
> Mac Mini with the full 2.6.21-ck1 patchset. I wish I'd tried it years ago!
>
> This also prompted me to have a play with CFS, but for my desktop workload on either machine, SD
> just "felt" better (for whatever that may be worth).

No doubt about the goodnes of the SD scheduler, Con did an amazing
work dnd even if we don't know whether SD will be merged in mailine
(CFS seems to be the best candidate) he demonstrated that there is
plenty of room for improvment in that area.

Brad, is it possible for you to do some more test with the latest
version of both SD and CFS  and post some more detailed feedbacks?
That would help a lot.

> +1 for SD
> +1 for swap-prefetch
>

Regards,

-- 
Paolo
