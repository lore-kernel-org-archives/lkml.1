Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYHFStx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYHFStx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYHFStp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:49:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52028 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbYHFStp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:49:45 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
From: Andi Kleen <andi@firstfloor.org>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	<20080730014308.2a447e71.akpm@linux-foundation.org>
	<20080730172317.GA14138@csn.ul.ie>
	<20080730103407.b110afc2.akpm@linux-foundation.org>
Date: Wed, 06 Aug 2008 20:49:40 +0200
In-Reply-To: <20080730103407.b110afc2.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 30 Jul 2008 10:34:07 -0700")
Message-ID: <87fxpi567v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> Do we expect that this change will be replicated in other
> memory-intensive apps?  (I do).

The catch with 2MB pages on x86 is that x86 CPUs generally have
much less 2MB TLB entries than 4K entries. So if you're unlucky
and access a lot of mappings you might actually thrash more with
them. That is why they are not necessarily an universal win.

-Andi
