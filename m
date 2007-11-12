Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbXKLRZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbXKLRZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXKLRZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:25:04 -0500
Received: from rtr.ca ([76.10.145.34]:3131 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbXKLRZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:25:03 -0500
Message-ID: <47388C6C.4020903@rtr.ca>
Date: Mon, 12 Nov 2007 12:25:00 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
References: <1194601672.20251.60.camel@ymzhang>	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>	 <1194860728.7179.6.camel@twins>  <1194861112.20251.124.camel@ymzhang> <1194873980.7179.31.camel@twins>
In-Reply-To: <1194873980.7179.31.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
..
> While I see that the write speed as reported under .24 ~70MB/s is much
> lower than the one reported under .23 ~200MB/s, I find it very hard to
> believe my poor single SATA disk could actually do the 200MB/s for
> longer than its cache 8/16 MB (not sure).
> 
> vmstat shows that actual IO is done, even though the whole 512MB could
> fit in cache, hence my suspicion that the ~70MB/s is the most realistic
> of the two.
..

Yeah, sequential 70MB/sec is quite realistic for a modern SATA drive.

But significantly faster than that (say, 100MB/sec +) is unlikely at present.
