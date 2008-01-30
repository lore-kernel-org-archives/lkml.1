Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYA3AaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYA3AaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbYA3AaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:30:04 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48128 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113AbYA3A2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:28:06 -0500
Date: Tue, 29 Jan 2008 18:28:05 -0600
From: Jack Steiner <steiner@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Message-ID: <20080130002804.GA13840@sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com> <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com> <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random> <Pine.LNX.4.64.0801291620170.28027@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801291620170.28027@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 04:20:50PM -0800, Christoph Lameter wrote:
> On Wed, 30 Jan 2008, Andrea Arcangeli wrote:
> 
> > > invalidate_range after populate allows access to memory for which ptes 
> > > were zapped and the refcount was released.
> > 
> > The last refcount is released by the invalidate_range itself.
> 
> That is true for your implementation and to address Robin's issues. Jack: 
> Is that true for the GRU?

I'm not sure I understand the question. The GRU never (currently) takes
a reference on a page. It has no mechanism for tracking pages that
were exported to the external TLBs.

--- jack
