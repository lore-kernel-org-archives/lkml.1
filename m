Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYBJI0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYBJI0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYBJI00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 03:26:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbYBJI0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 03:26:25 -0500
Date: Sun, 10 Feb 2008 03:26:24 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210082624.GB10479@infradead.org>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082132.GA9878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210082132.GA9878@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 09:21:32AM +0100, Ingo Molnar wrote:
> > Kerneldoc comments don't belong above the prototype of a function but 
> > the function body.
> 
> disagree - the best is to have it in both places - and in many places we 
> do that. Anyway, this is up to maintainer discretion.

Huh?  In both places is the worst idea ever.  It just means things
will 100% sure get out of sync.  And the reason why it should be at the
function declaration is because that's where the kerneldoc tool picks
it up.

