Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZBWAEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZBWAEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZBWAEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:04:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51892 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbZBWAEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:04:34 -0500
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
From: Andi Kleen <andi@firstfloor.org>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Date: Mon, 23 Feb 2009 01:02:59 +0100
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> (Mel Gorman's message of "Sun, 22 Feb 2009 23:17:09 +0000")
Message-ID: <87ljryuij0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mel@csn.ul.ie> writes:


BTW one additional tuning opportunity would be to change cpusets to
always precompute zonelists out of line and then avoid doing
all these checks in the fast path.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
