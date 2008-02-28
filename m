Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbYB1AZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbYB1AZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYB1AYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:24:54 -0500
Received: from relay2.sgi.com ([192.48.171.30]:49700 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756200AbYB1AYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:24:54 -0500
Date: Wed, 27 Feb 2008 16:24:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org, akpm@linux-foundation.org
Subject: Re: [kvm-devel] [PATCH] mmu notifiers #v7
In-Reply-To: <20080228002121.GC8091@v2.random>
Message-ID: <Pine.LNX.4.64.0802271624170.15965@schroedinger.engr.sgi.com>
References: <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random>
 <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de>
 <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com>
 <20080227192610.GF28483@v2.random> <Pine.LNX.4.64.0802271503050.13186@schroedinger.engr.sgi.com>
 <20080227234317.GM28483@v2.random> <Pine.LNX.4.64.0802271605480.15667@schroedinger.engr.sgi.com>
 <20080228002121.GC8091@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Andrea Arcangeli wrote:

> I'm not suggesting not to address the issues, just that those issues
> requires VM core changes, and likely those changes should be
> switchable under a CONFIG_XPMEM, so I see no reason to delay the mmu
> notifier until those changes are done and merged too. It's kind of a
> separate problem.

No its the core problem of the mmu notifier. It needs to be usable for a 
lot of scenarios.

 
