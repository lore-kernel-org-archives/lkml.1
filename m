Return-Path: <linux-kernel-owner+w=401wt.eu-S1764916AbYDVPjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764916AbYDVPjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762448AbYDVPj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:39:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762119AbYDVPj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:39:28 -0400
Message-ID: <480E06A6.1080803@redhat.com>
Date: Tue, 22 Apr 2008 10:39:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/4] mark various functions as noinline_for_stack
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After I noinlined a few sys_mount helpers for stack reasons, there was
discussion of a special self-documenting noinline.  I said I'd send a
patch to do that, but shirked my duty.  I see that Andrew has put
"noinline_for_stack" into place already.... as penance, I've gone
through a few subsystems using "noinline" and where specific
stack-related comments existed, I replaced noinline with
noinline_for_stack and removed the comments.

Thanks,
-Eric
