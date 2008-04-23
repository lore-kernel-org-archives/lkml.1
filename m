Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbYDWRJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbYDWRJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYDWRJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:09:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848AbYDWRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:09:26 -0400
Date: Wed, 23 Apr 2008 12:09:09 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080423170909.GA1459@sgi.com>
References: <patchbomb.1208872276@duo.random> <ea87c15371b1bd49380c.1208872277@duo.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea87c15371b1bd49380c.1208872277@duo.random>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You may have spotted this already. If so, just ignore this.

It looks like there is a bug in copy_page_range() around line 667.
It's possible to do a mmu_notifier_invalidate_range_start(), then
return -ENOMEM w/o doing a corresponding mmu_notifier_invalidate_range_end().

--- jack


