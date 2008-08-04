Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYHDNVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYHDNVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYHDNTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:19:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41873 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbYHDNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:19:41 -0400
Message-Id: <20080804130317.994042639@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 04 Aug 2008 15:03:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [RFC][PATCH 0/7] lockdep
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is my pending lockdep queue, it includes David's graph optimization,
my new scheduler runqueue annotation amongst others.

The part that makes this RFC are the latter few patches that add the "lock
protection locks" thing Linus proposed a few days ago. I've not yet written a
test case that actively tests this functionality, but wanted to get this out so
that Jeremy can see if it works for him.

Enjoy..
-- 

