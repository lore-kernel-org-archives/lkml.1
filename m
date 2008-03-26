Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYCZR6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYCZR6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbYCZR6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:58:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54288 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758213AbYCZR6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:58:14 -0400
Date: Wed, 26 Mar 2008 10:56:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
In-Reply-To: <18409.56843.909298.717089@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0803261052550.29859@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
 <20080321.145712.198736315.davem@davemloft.net>
 <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
 <20080324.133722.38645342.davem@davemloft.net> <18408.29107.709577.374424@cargo.ozlabs.ibm.com>
 <87wsnrgg9q.fsf@basil.nowhere.org> <18409.56843.909298.717089@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Paul Mackerras wrote:

> So the improvement in the user time is almost all due to the reduced
> TLB misses (as one would expect).  For the system time, using 64k
> pages in the VM reduces it by about 21%, and using 64k hardware pages
> reduces it by another 30%.  So the reduction in kernel overhead is
> significant but not as large as the impact of reducing TLB misses.

One should emphasize that this test was a kernel compile which is not 
a load that gains much from larger pages. 4k pages are mostly okay for 
loads that use large amounts of small files.


