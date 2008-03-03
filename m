Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbYCCVQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbYCCVQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYCCVPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:15:52 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:46303
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYCCVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:15:51 -0500
Date: Mon, 3 Mar 2008 22:15:32 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v8
Message-ID: <20080303211532.GX8091@v2.random>
References: <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random> <20080303032934.GA3301@wotan.suse.de> <Pine.LNX.4.64.0803031058230.6917@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803031058230.6917@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 11:01:22AM -0800, Christoph Lameter wrote:
> API still has rcu issues and the example given for making things sleepable 
> is only working for the aging callback. The most important callback is for 
> try_to_unmao and page_mkclean. This means the API is still not generic 
> enough and likely not extendable as needed in its present form.

I converted only one of those _notify as an example of how it should
be done, because I assumed you volunteer to convert the other ones
yourself during .26. It's useless to convert all of them right now,
because the i_mmap_lock and anon_vma locks are still going to be
spinlocks in .25.
