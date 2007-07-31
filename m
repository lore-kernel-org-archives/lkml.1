Return-Path: <linux-kernel-owner+w=401wt.eu-S932365AbXGaQWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbXGaQWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763060AbXGaQWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:22:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58400 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbXGaQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:22:24 -0400
Subject: Re: [PATCH 0/2][RFC] VFCIPI v3
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <46AF2752.BA47.005A.0@novell.com>
References: <20070731132153.4790.37217.stgit@novell1.haskins.net>
	 <1185891957.12034.12.camel@twins> <46AF1DA6.BA47.005A.0@novell.com>
	 <1185896412.12034.17.camel@twins>  <46AF2752.BA47.005A.0@novell.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 18:22:20 +0200
Message-Id: <1185898941.12034.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 12:14 -0400, Gregory Haskins wrote:

> Out of curiosity and for my own edification:  What *is* GFP_ATOMIC meant for?

It is meant as you used it, _except_ for !PREEMPT_RT.

With PREEMPT_RT all allocators are fully preemptable, that is both the
slab as well as the underlying page allocator.

Allocation from atomic context is a BUG() with -rt.

