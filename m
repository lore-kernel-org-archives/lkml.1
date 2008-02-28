Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbYB1Amm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbYB1Amm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYB1Amf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:42:35 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:55744
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbYB1Ame (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:42:34 -0500
Date: Thu, 28 Feb 2008 01:42:26 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps
	(f.e. for XPmem)
Message-ID: <20080228004226.GE8091@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215064933.376635032@sgi.com> <200802201055.21343.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271440530.13186@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271440530.13186@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 02:43:41PM -0800, Christoph Lameter wrote:
> Nope. unmap_mapping_range is already handled by the range callbacks.

But they're called with atomic=1 on anything but anonymous memory. I
understood Andrew asked to remove the atomic param and to allow
sleeping for all kind of vmas. I also understood certain XPMEM
customers asked to use XPMEM on something more than anonymous memory.

> The situation that you are imagining has already been dealt with [..]

I guess there's some misunderstanding, I think Nick was referring to
the above problem.
