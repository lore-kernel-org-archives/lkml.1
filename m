Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbXHVMdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbXHVMdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760679AbXHVMc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:32:58 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:63419 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbXHVMc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:32:57 -0400
Message-Id: <20070822123603.501231302@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 14:36:03 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/10] s390 patches for 2.6.23-rc3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

10 patches for s390. The new vmur driver still has some rough edges
but we are getting there. Patch #10 is our solution to the atomic_t
vs. volatile problem. As prediced by Linus adding a barrier to
atomic_read/atomic_set has close to zero impact to the generated
code and adding the barrier to atomic_read/atomic_set forces the
compiler to read/write the value to/from memory. This seems to be
the most convenient way to solve this problem.

--
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

