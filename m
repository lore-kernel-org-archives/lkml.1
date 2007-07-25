Return-Path: <linux-kernel-owner+w=401wt.eu-S1763684AbXGYIbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763684AbXGYIbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbXGYIbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:31:18 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:40082 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbXGYIbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:31:17 -0400
Message-ID: <46A709DC.4080501@gmail.com>
Date: Wed, 25 Jul 2007 10:29:16 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: david@lang.hm
CC: Ray Lee <ray-lk@madrabbit.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>  <200707102015.44004.kernel@kolivas.org>  <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>  <46A57068.3070701@yahoo.com.au>  <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>  <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <Pine.LNX.4.64.0707242130470.2229@asgard.lang.hm> <46A7031D.5080300@gmail.com> <Pine.LNX.4.64.0707250104180.2229@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707250104180.2229@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2007 10:07 AM, david@lang.hm wrote:

> On Wed, 25 Jul 2007, Rene Herman wrote:

>> Something like this?

[ ... ]

> when the swap readahead is enabled does it make a significant difference 
> in the time to do the random access?

I don't use swap prefetch (nor -ck or -mm). If someone who has the patch 
applied waits to hit enter until swap prefetch has prefetched it all back in 
again, it certainly will.

Swap prefetch's potential to do larger reads back from swapspace than a 
random segfaulting app could well be very significant. Reads are dwarved by 
seeks. If this program does what you wanted, please use it to show us.

Rene.
