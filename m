Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYKWSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYKWSZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYKWSZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:25:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbYKWSZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:25:27 -0500
Date: Sun, 23 Nov 2008 10:24:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
Message-Id: <20081123102453.f549da39.akpm@linux-foundation.org>
In-Reply-To: <20081123091843.GK30453@elte.hu>
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com>
	<20081123091843.GK30453@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008 10:18:44 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> * Ying Han <yinghan@google.com> wrote:
> 
> > page fault retry with NOPAGE_RETRY
> 
> Interesting patch.

<a grey call stirs>

ahhh...  I thought this all sounded familiar.  It surfaced a couple of
years ago, and this was my summary of the intent at the time:

http://lkml.indiana.edu/hypermail/linux/kernel/0609.1/2106.html

It all went round and round for a while, but I don't think anything got
merged.  In fact I can't even find Ben's original little spufs/cell
NOPAGE_RETRY code in the tree, an I thought we merged that.  Confused.

The questions are, of course: does this new code address the issues
which were raised at that time?

