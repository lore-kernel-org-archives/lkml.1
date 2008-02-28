Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbYB1BCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbYB1BCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYB1BBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:01:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:58621 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753534AbYB1BBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:01:52 -0500
Date: Wed, 27 Feb 2008 17:01:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps
 (f.e. for XPmem)
In-Reply-To: <20080228004226.GE8091@v2.random>
Message-ID: <Pine.LNX.4.64.0802271701250.16510@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064933.376635032@sgi.com>
 <200802201055.21343.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0802271440530.13186@schroedinger.engr.sgi.com>
 <20080228004226.GE8091@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Andrea Arcangeli wrote:

> On Wed, Feb 27, 2008 at 02:43:41PM -0800, Christoph Lameter wrote:
> > Nope. unmap_mapping_range is already handled by the range callbacks.
> 
> But they're called with atomic=1 on anything but anonymous memory. I
> understood Andrew asked to remove the atomic param and to allow
> sleeping for all kind of vmas. I also understood certain XPMEM
> customers asked to use XPMEM on something more than anonymous memory.

Yes but the patch that is discussed here does not handle that situation.
