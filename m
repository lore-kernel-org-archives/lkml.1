Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYFEQvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYFEQvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYFEQvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:51:09 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:53376
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYFEQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:51:08 -0400
Date: Thu, 5 Jun 2008 18:51:04 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 001/001] mmu-notifier-core v17
Message-ID: <20080605165104.GI15502@duo.random>
References: <20080509193230.GH7710@duo.random> <20080516190752.GK11333@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516190752.GK11333@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 12:07:52PM -0700, Paul E. McKenney wrote:
> The hlist_del_init_rcu() primitive looks good.
> 
> The rest of the RCU code looks fine assuming that "mn->ops->release()"
> either does call_rcu() to defer actual removal, or that the actual
> removal is deferred until after mmu_notifier_release() returns.

Yes, actual removal is deferred until after mmu_notifier_release()
returns.

> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks for the review Paul! I should also have added your precious
Acked-by to the 1/3 and 3/3 but the important is the ack by email ;)
