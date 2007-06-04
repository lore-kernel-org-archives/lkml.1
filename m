Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbXFDGKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbXFDGKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 02:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXFDGK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 02:10:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbXFDGK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 02:10:26 -0400
Date: Sun, 3 Jun 2007 23:08:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070603230859.5000424d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 15:51:13 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> A bitmap allocator made sense because it has the property of making 
> allocations compact. Once that requirement is relaxed, it does not make 
> any sense to use it (and you have still to modify it in any case).
> I generally agree on code re-use, but that just not the right structure. 
> You can tweak it how much you like, but you're still doing a search inside 
> an N-sized bitmap. It's just the *wrong* structure.

I must say that it's not really clear to me why this fdmap thing was
created.  Exactly what problem is it solving, and what properties is it
designed to have?

Could not a (prehaps suitably modified) IDR tree have adequately provided
those properties?

I'm sure it's good stuff, but the patches were presented as if we all know
what they're for.  But I don't.  Maybe I was asleep at the time.

