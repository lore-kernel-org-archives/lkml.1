Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZIURqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZIURqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZIURqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:46:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57024 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZIURqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:46:51 -0400
Date: Mon, 21 Sep 2009 18:46:57 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
Message-ID: <20090921174656.GS12726@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 05:10:23PM +0100, Mel Gorman wrote:
> Currently SLQB is not allowed to be configured on PPC and S390 machines as
> CPUs can belong to memoryless nodes. SLQB does not deal with this very well
> and crashes reliably.
> 
> These patches fix the problem on PPC64 and it appears to be fairly stable.
> At least, basic actions that were previously silently halting the machine
> complete successfully.

I spoke too soon. Stress tests result in application failure, nothing to
dmesg even with the patches applied so it looks like patch 2 is still the
wrong way to fix the OOM-kill storm.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
