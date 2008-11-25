Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYKYIr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYKYIr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYKYIrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:47:21 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:44330 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbYKYIrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:47:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAEhHK0lMROB9/2dsb2JhbACBbc9kgnw
Date: Tue, 25 Nov 2008 03:47:18 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       ltt-dev@lists.casi.polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] LTTng kernel integration roadmap, update
Message-ID: <20081125084718.GA28206@Krystal>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <20081125082414.GA28031@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081125082414.GA28031@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:46:51 up 8 days,  9:27,  1 user,  load average: 0.37, 0.59,
	0.53
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Nov 24, 2008 at 07:20:55AM -0500, Mathieu Desnoyers wrote:
> > The key idea behind this is to answer to Thomas Gleixner concerns, who
> > supports that a tracer should output data in text-format only so it can
> > be used with tools kernel developers have on their system, like "cat".
> 
> Last time I talked to Thomas and others it wasn't "text only" but text
> also in that you can just cat a debugfs file for simple tracing.  And I
> totally agree with that.  If you don't trace too much that's absolutely
> enough.  It's not enough for large traces on highly loaded enterprise
> or high-end embedded systems or things like flight recorder tracing, but
> for those requiring an external viewer is just fine.
> 

Ok, thanks for the clarification. This will be pretty much
straightforward to implement.

Mathieu

> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
