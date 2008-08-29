Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYH2ItB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYH2ItB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYH2Isw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:48:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYH2Isw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:48:52 -0400
Date: Fri, 29 Aug 2008 01:48:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: hugetlb.c make functions static, use NULL rather
 than 0
Message-Id: <20080829014809.be6689f6.akpm@linux-foundation.org>
In-Reply-To: <20080829082950.GC3387@brain>
References: <1219445274.4493.10.camel@brick>
	<Pine.LNX.4.64.0808251023220.8672@blonde.site>
	<20080829082950.GC3387@brain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 09:29:50 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> On Mon, Aug 25, 2008 at 10:27:39AM +0100, Hugh Dickins wrote:
> > On Fri, 22 Aug 2008, Harvey Harrison wrote:
> > 
> > > mm/hugetlb.c:265:17: warning: symbol 'resv_map_alloc' was not declared. Should it be static?
> > > mm/hugetlb.c:277:6: warning: symbol 'resv_map_release' was not declared. Should it be static?
> > > mm/hugetlb.c:292:9: warning: Using plain integer as NULL pointer
> > > mm/hugetlb.c:1750:5: warning: symbol 'unmap_ref_private' was not declared. Should it be static?
> 
> Harvey are you using some additional compiler flags to get this, I am
> pretty sure I checked for warnings during compilation before this lot
> was merged.  Hmmm.

sparse.   `make C=1'
