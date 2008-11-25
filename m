Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbYKYI7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbYKYI7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKYI6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:58:52 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34188 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbYKYI6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:58:51 -0500
Date: Tue, 25 Nov 2008 03:57:22 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081125085722.GJ20928@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	ltt-dev@lists.casi.polymtl.ca, Zhaolei <zhaolei@cn.fujitsu.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
	Sam Ravnborg <sam@ravnborg.org>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <20081125082414.GA28031@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125082414.GA28031@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 03:24:14AM -0500, Christoph Hellwig wrote:
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

I agree that we should have a text-based output format for kernel
hackers, as well as a binary high volume format.  I'd argue also that
since the text-based one would be used by kernel hackers, we don't
need to worry so much about keeping the format absolutely stable from
kernel version to kernel version (and it's not worth it to add version
tags to the text stream); people who care about a long-term, stable
interface should use the binary output format, IMHO.  

I'm not sure everyone will agree with me, but I think it helps to
simplify the effort behind the text-based output.

	  	     	 	       	       - Ted
