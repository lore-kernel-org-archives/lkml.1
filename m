Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZFHWbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZFHWbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZFHWbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:31:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58578 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408AbZFHWbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:31:35 -0400
Date: Mon, 8 Jun 2009 23:31:35 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] Add a gfp-translate script to help understand page
	allocation failure reports
Message-ID: <20090608223135.GB18437@csn.ul.ie>
References: <20090608132950.GB15070@csn.ul.ie> <28c262360906080725o1e6d9e93t465ffeb53b093a17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <28c262360906080725o1e6d9e93t465ffeb53b093a17@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 11:25:08PM +0900, Minchan Kim wrote:
> Hi, Mel.
> 
> How about handling it in kernel itself ?
> 

I posted a prototype patch that does something like that. It's not exactly
trivial to support without duplicating a pile of code or being very specific
to one use-case. I might have over-complicated things though.

> I mean we can print human-readable pretty format instead of
> non-understandable hex value. It can help us without knowing other's
> people's machine configuration.
> 

The downsides of handling this in kernel is that more strings are needed,
more code and it won't be of any use with reports from older kernels,
particularly distro kernels. There is scope for both having the script and
formatting it in-kernel.

> BTW, It would be better than now by your script.
> Thanks for sharing good tip. :)
> 

You're welcome.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
