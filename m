Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXBYANu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXBYANu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbXBYANu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:13:50 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39787 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933603AbXBYANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:13:49 -0500
Date: Sat, 24 Feb 2007 16:13:47 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Hugh Dickins <hugh@veritas.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
In-Reply-To: <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0702241612470.4891@schroedinger.engr.sgi.com>
References: <20070223212303.GA423@tv-sign.ru> <Pine.LNX.4.64.0702242203080.4370@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, Hugh Dickins wrote:

> Two, in his SLUB thread it sounds like he's toying with mixing up kmem
> caches of similar sizes: that seems a really bad idea to me (for reasons
> Andi and others have made) and I expect it'll get dropped; but in case
> not, let's note that the anon_vma cache is one which would fare very
> badly from getting mixed in with others (lock would no longer remain
> a lock, list would no longer remain a list, across that race).

Dont worry DESTROY_BY_RCU slabs wont be mixed with those not marked 
DESTROY_BY_RCU.
