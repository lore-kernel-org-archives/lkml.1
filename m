Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZKTVbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZKTVbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbZKTV23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34626 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbZKTV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:26 -0500
Message-Id: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:42 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] perf_event patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some perf patches, most resulting from chasing Corey's scale issue.

There's still one issue open with that and that is that we're reading
->total_time_{enabled,running} without serialization.

Please have a thorough look at 7-14.

It also removes all the system_state == STATE_RUNNING muck from
everywhere and it still boots, which leaves me wondering what changed to
not make things go boom.

