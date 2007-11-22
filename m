Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXKVAbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXKVAbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbXKVAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:31:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50514 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752928AbXKVAbQ (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:31:16 -0500
Date: Thu, 22 Nov 2007 11:31:00 +1100
From: David Chinner <dgc@sgi.com>
To: xfs-oss <xfs@oss.sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9]: Various XFS inode clustering improvements
Message-ID: <20071122003100.GF114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Normally I wouldn't bother cc'ing lkml on XFS changes, however a
couple of these patches touch generic code. The changes to generic
code are introducing a WRITE_META bio type and
radix_tree_gang_lookup_range() and hence the wider ditribution.
This patch set is against the current xfs-dev tree so bits of
it may not apply to current mainline.

Overall, the patch set is focussed on improving the XFS inode
cache and clustering code. It reduces memory usage of the
cache by 5-10% and improves performance on some workloads
by 10-15%.

Comments welcome.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
