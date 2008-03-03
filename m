Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYCCTEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYCCTEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760620AbYCCTE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:04:26 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45039 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755942AbYCCTEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:04:25 -0500
Date: Mon, 3 Mar 2008 11:04:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrea Arcangeli <andrea@qumranet.com>, Jack Steiner <steiner@sgi.com>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v8
In-Reply-To: <20080303033428.GD3301@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803031103530.6917@schroedinger.engr.sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random>
 <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random>
 <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de>
 <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com>
 <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random>
 <20080303033428.GD3301@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> Move definition of struct mmu_notifier and struct mmu_notifier_ops under
> CONFIG_MMU_NOTIFIER to ensure they doesn't get dereferenced when they
> don't make sense.

The callbacks take a mmu_notifier parameter. So how does this compile for 
!MMU_NOTIFIER?

