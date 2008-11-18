Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbYKRJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbYKRJxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYKRJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:53:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYKRJxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:53:09 -0500
Date: Tue, 18 Nov 2008 04:53:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
Message-ID: <20081118095305.GA24119@infradead.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <1226963005.7178.248.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226963005.7178.248.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 10:03:25AM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2008-11-17 at 15:34 -0500, Steven Rostedt wrote:
> > Note, I was using a default config that had CONFIG_IRQSTACKS off and
> > CONFIG_PPC_64K_PAGES on.
> 
> For one, we definitely need to turn IRQSTACKS on by default ... In fact,
> I'm pondering just removing the option.

It shouldn't be a user-visible option.  It shouldn't on x86 either, but
there it always gets into the ideological 4k stacks flameware so people
usually gave up after a while instead of doing the sensibke 8k +
irqstacks by default, 4k as an option..

