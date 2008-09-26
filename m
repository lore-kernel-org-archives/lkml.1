Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYIZRgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYIZRgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYIZRgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:36:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYIZRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:36:04 -0400
Message-Id: <20080926173219.885155151@twins.programming.kicks-ass.net>
User-Agent: quilt/0.47-1
Date: Fri, 26 Sep 2008 19:32:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 0/4] futex: get_user_pages_fast() for shared futexes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since get_user_pages_fast() made it in, I thought to give this another try.
Lightly tested by disabling the private futexes and running some java proglets.


