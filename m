Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYKFPhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYKFPhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYKFPg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:36:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbYKFPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:36:27 -0500
Date: Thu, 6 Nov 2008 10:36:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       T?r?k Edwin <edwintorok@gmail.com>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081106153600.GA12523@infradead.org>
References: <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu> <20081104182628.GA6666@infradead.org> <20081106095547.GK4890@elte.hu> <20081106122650.GA23474@infradead.org> <20081106153238.GD1644@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106153238.GD1644@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:32:38PM +0100, Ingo Molnar wrote:
> the timeline i quoted shows that it was a 2 days process, not 2 
> minutes.

Honestly I'm not sure what this timeline stuff should mean. People are
busy, and for many of us kernel hacking is only or at least outside
of very narrow areas a spare time activicty, so you really can't expect
answers in the next minute.  There might be a lot of real life stuff
that's a lot more important as it pais the bills and deals with family,
etc.

But that wasn't my point anyway.  Al told no to seq_path, and just
the contents of it without the interface that is tied to seq_files.
Doing so is trivial by looking at seq_path so I really don't understand
your odd reaction to it.

