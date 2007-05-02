Return-Path: <linux-kernel-owner+w=401wt.eu-S1767250AbXEBS6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767250AbXEBS6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767248AbXEBS6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:58:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49258 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767247AbXEBS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:58:05 -0400
Date: Wed, 2 May 2007 11:58:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070502185201.GA12097@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0705021156300.1220@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <20070501133618.93793687.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com>
 <20070502185201.GA12097@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Siddha, Suresh B wrote:

> I have been looking into "slub" recently to avoid some of the NUMA alien
> cache issues that we were encountering on the regular slab.

Yes that is also our main concern.

> I am having some stability issues with slub on an ia64 NUMA platform and
> didn't have time to dig further. I am hoping to look into it soon
> and share the data/findings with  Christoph.

There is at least one patch on top of 2.6.21-rc7-mm2 already in mm that 
may be necessary for you.
