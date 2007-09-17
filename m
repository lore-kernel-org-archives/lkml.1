Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbXIQWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbXIQWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbXIQWZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:25:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:42323 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161AbXIQWZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:25:46 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH]  2.6.23-rc6:  Fix NUMA Memory Policy Reference Counting
Date: Tue, 18 Sep 2007 00:25:40 +0200
User-Agent: KMail/1.9.6
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       eric.whitney@hp.com, Mel Gorman <mel@csn.ul.ie>
References: <20070830185053.22619.96398.sendpatchset@localhost> <1190057534.5460.131.camel@localhost> <Pine.LNX.4.64.0709171235190.28178@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709171235190.28178@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709180025.40837.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The patch does require concurrent increments and decrements in the main 
> fault patch. The potential is to create another bouncing cacheline for 
> concurrent faults. This looks like it would cause a performance issue.

While may be true correctness is always more important than performance.
So I think this is the right thing for .23. Any performance improvements
if needed can come later.

-Andi
