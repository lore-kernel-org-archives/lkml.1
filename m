Return-Path: <linux-kernel-owner+w=401wt.eu-S932400AbZLRSnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbZLRSnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZLRSnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:43:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48350 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZLRSnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:43:23 -0500
Date: Fri, 18 Dec 2009 19:43:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091218184321.GC17509@basil.fritz.box>
References: <20091217175338.GL9804@basil.fritz.box> <20091217190804.GB6788@linux.vnet.ibm.com> <20091217195530.GM9804@basil.fritz.box> <alpine.DEB.2.00.0912171356020.4640@router.home> <1261080855.27920.807.camel@laptop> <alpine.DEB.2.00.0912171439380.4640@router.home> <20091218051754.GC417@elte.hu> <4B2BB52A.7050103@redhat.com> <20091218171240.GB1354@elte.hu> <alpine.DEB.2.00.0912181207010.26947@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912181207010.26947@router.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The existing locking APIs are all hiding lock details at various levels.
> We have various specific APIs for specialized locks already Page locking
> etc.
> 
> How can we make progress on this if we cannot look at the mmap_sem

The point was to really make progress on vma locking we need new
semantics (finer grained range locking) that cannot be provided by a
simple wrapper.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
