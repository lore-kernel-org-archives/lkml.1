Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbYEEUnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbYEEUnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYEEUnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:43:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbYEEUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:43:35 -0400
Date: Mon, 5 May 2008 13:42:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: bunk@kernel.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, sam@ravnborg.org, viro@ftp.linux.org.uk,
       hpa@zytor.com
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-Id: <20080505134252.c82a64f6.akpm@linux-foundation.org>
In-Reply-To: <20080505201906.GA900@elte.hu>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
	<20080505201906.GA900@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 22:19:06 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Firstly, the practical problem: today "make namespacecheck" emits way 
> too many false positives even on an allyesconfig build

We don't actually care about what comes out of `make namespacecheck'.  We
care about the _difference_ in its output when a patch is applied.

So a script which reports on what changes a particular patch has upon
namespacecheck output might be the way to go.  If it is fast enough then it
can be run on a per-patch basis alongside checkpatch.

