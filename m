Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbYKYIYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbYKYIYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYKYIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:24:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYKYIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:24:24 -0500
Date: Tue, 25 Nov 2008 03:24:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081125082414.GA28031@infradead.org>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124122055.GA18626@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 07:20:55AM -0500, Mathieu Desnoyers wrote:
> The key idea behind this is to answer to Thomas Gleixner concerns, who
> supports that a tracer should output data in text-format only so it can
> be used with tools kernel developers have on their system, like "cat".

Last time I talked to Thomas and others it wasn't "text only" but text
also in that you can just cat a debugfs file for simple tracing.  And I
totally agree with that.  If you don't trace too much that's absolutely
enough.  It's not enough for large traces on highly loaded enterprise
or high-end embedded systems or things like flight recorder tracing, but
for those requiring an external viewer is just fine.

