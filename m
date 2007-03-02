Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXCBNwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXCBNwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933357AbXCBNwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:52:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51426 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbXCBNwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:52:43 -0500
Subject: Re: The performance and behaviour of the anti-fragmentation
	related patches
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@skynet.ie>, npiggin@suse.de, clameter@engr.sgi.com,
       mingo@elte.hu, jschopp@austin.ibm.com, torvalds@linux-foundation.org,
       mbligh@mbligh.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070301160915.6da876c5.akpm@linux-foundation.org>
References: <20070301101249.GA29351@skynet.ie>
	 <20070301160915.6da876c5.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 02 Mar 2007 05:50:57 -0800
Message-Id: <1172843457.3237.11.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 16:09 -0800, Andrew Morton wrote:
> And I'd judge that per-container RSS limits are of considerably more value
> than antifrag (in fact per-container RSS might be a superset of antifrag,
> in the sense that per-container RSS and containers could be abused to fix
> the i-cant-get-any-hugepages problem, dunno).


Hi,

the RSS thing is.. .funky.
I'm saying that because we have not been able to define what RSS means,
so before we expand how RSS is used that needs solving first.

This is relevant for the pagetable sharing patches: if RSS can exclude
shared, they're relatively easy. If RSS has to include shared always, we
have currently a problem because hugepages aren't part of RSS right now.

I would really really really like to see this unclarity sorted out on
the concept level before going through massive changes in the code based
on something so fundamentally unclear.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

