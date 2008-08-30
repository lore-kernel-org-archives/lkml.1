Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYH3QET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYH3QET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 12:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYH3QEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 12:04:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:60025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYH3QEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 12:04:09 -0400
Date: Sat, 30 Aug 2008 09:04:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Joe Korty <joe.korty@ccur.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make might_sleep() display the oopsing process
Message-ID: <20080830090411.03791b5a@infradead.org>
In-Reply-To: <20080830144520.GB10821@tsunami.ccur.com>
References: <20080827152139.GA11460@tsunami.ccur.com>
	<20080828093628.GA28783@elte.hu>
	<20080829162003.8f66cafe.akpm@linux-foundation.org>
	<20080830144520.GB10821@tsunami.ccur.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 10:45:20 -0400
Joe Korty <joe.korty@ccur.com> wrote:

> On Fri, Aug 29, 2008 at 07:20:03PM -0400, Andrew Morton wrote:
> > On Thu, 28 Aug 2008 11:36:28 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > Expand might_sleep's printk to indicate the oopsing process.
> > >
> > > good idea
> > 
> > Why?  I don't recall ever having been interested in this
> > information.
> > 
> > (I shouldn't have to ask questions like this.  Please spend a little
> > more time in preparing the patch descriptions).
> 
> I wrote and used the patch once, as I wanted to know
> which program in a lengthy multiple-program test suite
> was triggering the problem.  That made it easier coming
> up with a shortened test that would replicate the problem.
> 
> However I only needed it that one time so this patch can
> be considered to be exceptionally optional :)

WARN() and WARN_ON() already print the oopsing process.
so if might_sleep() just calls one of those it already prints it.
If it doesn't call one of these.. maybe it should?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
