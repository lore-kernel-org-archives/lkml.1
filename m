Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbYAaCnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbYAaCnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbYAaCmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:42:55 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59772
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbYAaCmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:42:55 -0500
Date: Thu, 31 Jan 2008 03:42:52 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       steiner@sgi.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [patch 2/6] mmu_notifier: Callbacks to invalidate
	address ranges
Message-ID: <20080131024252.GF7185@v2.random>
References: <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com> <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com> <20080130182506.GQ7233@v2.random> <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com> <20080130235214.GC7185@v2.random> <Pine.LNX.4.64.0801301555550.1722@schroedinger.engr.sgi.com> <20080131003434.GE7185@v2.random> <Pine.LNX.4.64.0801301805200.14071@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301805200.14071@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 06:08:14PM -0800, Christoph Lameter wrote:
>  		hlist_for_each_entry_safe_rcu(mn, n, t,
				         ^^^^

>  					  &mm->mmu_notifier.head, hlist) {
>  			hlist_del_rcu(&mn->hlist);
				 ^^^^

_rcu can go away from both, if hlist_del_rcu can be called w/o locks.
