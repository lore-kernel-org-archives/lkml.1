Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbXIXLPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbXIXLPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbXIXLO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:14:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34521 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbXIXLO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:14:59 -0400
Date: Mon, 24 Sep 2007 12:14:57 +0100
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070924111456.GD3968@skynet.ie>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070918174408.GC1804@skynet.ie> <alpine.LFD.0.999.0709221409260.22517@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709221409260.22517@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (22/09/07 14:11), Satyam Sharma didst pronounce:
> 
> > -static volatile int kgdb_hwbreak_sstep[NR_CPUS];
> > +volatile int kgdb_hwbreak_sstep[NR_CPUS];
> 
> That looks fishy to me. Why is it volatile-qualified?

It turned out that it was unnecessary. A follow-up patch removed the volatile
and kept the static.

> And does that
> actually want to be a per-cpu var?
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
