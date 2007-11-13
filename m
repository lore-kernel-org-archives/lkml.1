Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXKMBua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXKMBua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbXKMBuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:50:19 -0500
Received: from mga10.intel.com ([192.55.52.92]:64793 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756794AbXKMBuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:50:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,408,1188802800"; 
   d="scan'208";a="202024844"
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47388C6C.4020903@rtr.ca>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
	 <1194860728.7179.6.camel@twins>  <1194861112.20251.124.camel@ymzhang>
	 <1194873980.7179.31.camel@twins>  <47388C6C.4020903@rtr.ca>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 Nov 2007 09:49:04 +0800
Message-Id: <1194918544.20251.133.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-12 at 12:25 -0500, Mark Lord wrote:
> Peter Zijlstra wrote:
> ..
> > While I see that the write speed as reported under .24 ~70MB/s is much
> > lower than the one reported under .23 ~200MB/s, I find it very hard to
> > believe my poor single SATA disk could actually do the 200MB/s for
> > longer than its cache 8/16 MB (not sure).
> > 
> > vmstat shows that actual IO is done, even though the whole 512MB could
> > fit in cache, hence my suspicion that the ~70MB/s is the most realistic
> > of the two.
> ..
> 
> Yeah, sequential 70MB/sec is quite realistic for a modern SATA drive.
> 
> But significantly faster than that (say, 100MB/sec +) is unlikely at present.
I just use command '#iozone -i 0 -r 4k -s 512m', no '-e -c'. So if
we consider cache, the speed is very fast. On my machine with 2.6.23, the write speed is
631M/s, quite fast. :)
