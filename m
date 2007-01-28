Return-Path: <linux-kernel-owner+w=401wt.eu-S932547AbXA1NdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbXA1NdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbXA1Nas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:30:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585AbXA1N3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:29:30 -0500
Message-Id: <20070128131343.628722000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 14:13:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/14] Concurrent Page Cache
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With Nick leading the way to getting rid of the read side of the tree_lock,
this work continues by breaking the write side of said lock.

Aside from breaking MTD this version of the concurrent page cache seems
rock solid on my dual core x86_64 box.


