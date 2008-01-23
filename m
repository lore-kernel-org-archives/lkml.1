Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYAWL0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYAWL0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYAWL0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:26:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40528 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbYAWL0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:26:10 -0500
Date: Wed, 23 Jan 2008 11:24:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86 II
Message-ID: <20080123112436.GF21455@csn.ul.ie>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <200801231145.14915.andi@firstfloor.org> <20080123105757.GE21455@csn.ul.ie> <200801231215.56741.andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200801231215.56741.andi@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/01/08 12:15), Andi Kleen didst pronounce:
> 
> Anyways from your earlier comments it sounds like you're trying to add SRAT 
> parsing to CONFIG_NUMAQ. Since that's redundant with the old implementation
> it doesn't sound like a very useful thing to do.
> 

No, that would not be useful at all as it's redundant as you point out. The
only reason to add it is if the Opteron box can figure out the CPU-to-node
affinity. Right now everything gets dumped into node 0 where as x86_64
can figure it out properly.

> But the patch is applied already i think. Well I'm sure it passed 
> checkpatch.pl at least.
> 

:| The patches applied so far are about increasing test coverage, not SRAT
messing. While there are still breakages for some boxen, more configurations
should work on more machines than previously. Those using non-NUMA .configs
should not notice the difference.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
