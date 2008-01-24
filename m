Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbYAXPPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbYAXPPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYAXPPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:15:46 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:34223
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYAXPPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:15:45 -0500
Message-ID: <4798AB96.4000408@qumranet.com>
Date: Thu, 24 Jan 2008 17:15:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Christoph Lameter <clameter@sgi.com>, Izik Eidus <izike@qumranet.com>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <20080123114136.GE15848@v2.random> <Pine.LNX.4.64.0801231149150.13547@schroedinger.engr.sgi.com> <20080124143454.GN7141@v2.random>
In-Reply-To: <20080124143454.GN7141@v2.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> The remote page fault
>   

As we have two names for this ('shadow' and 'remote/export') I'd like to 
suggest a neutral nomenclature.  How about 'secondary mmu' (and 
secondary ptes (sptes), etc.)?  I think this fits xpmem, kvm, rdma, and dri.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

