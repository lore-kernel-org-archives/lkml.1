Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXA2RUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXA2RUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXA2RUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:20:44 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:41674 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752024AbXA2RUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:20:43 -0500
Date: Mon, 29 Jan 2007 09:20:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 00/14] Concurrent Page Cache
In-Reply-To: <20070128131343.628722000@programming.kicks-ass.net>
Message-ID: <Pine.LNX.4.64.0701290918260.28330@schroedinger.engr.sgi.com>
References: <20070128131343.628722000@programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007, Peter Zijlstra wrote:

> With Nick leading the way to getting rid of the read side of the tree_lock,
> this work continues by breaking the write side of said lock.

Could we get the read side in separately from the write side? I think I 
get the read side but the write side still looks scary to me and 
introduces new ways of locking. Ladder locking?
 
> Aside from breaking MTD this version of the concurrent page cache seems
> rock solid on my dual core x86_64 box.

What exactly is the MTD doing and how does it break?
