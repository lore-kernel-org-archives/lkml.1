Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbXFKRhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbXFKRhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbXFKRhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:37:41 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbXFKRhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:37:40 -0400
Message-ID: <466D882D.70001@zytor.com>
Date: Mon, 11 Jun 2007 10:36:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com>
In-Reply-To: <20070611172006.GI9174@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> FWIW, waay back when (sometime last year if memory serves)
> Linus suggested changing the default to 0x1000000 for all x86.
> The reasoning was some performance microoptimisation regarding
> 4MB aligned TLBs iirc.
> 
> The details have long since evaded my memory, but as an experiment,
> I made the change to the Fedora kernel.  FC5,FC6 and F7 have been
> this way for a while now, with no obvious problems. Ditto RHEL5.
> We did get some performance numbers at the time of the change,
> but they weren't amazing (basically in the noise).
> Given it never seemed to actually get worse, I never got around
> to reverting it..
> 

Picking the 16 MB base is a bit obnoxious on small-memory machines, 4 MB
would probably be a more reasonable base.  Of course, 16 MB would avoid
  the issue of the handful of machines with memory holes at 15-16 MB.

	-hpa
