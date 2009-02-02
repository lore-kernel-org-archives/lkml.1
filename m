Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZBBOpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZBBOpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZBBOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:45:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:42820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZBBOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:45:35 -0500
Date: Mon, 2 Feb 2009 06:45:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090202064525.3df9db9f@infradead.org>
In-Reply-To: <4986B684.5000506@s5r6.in-berlin.de>
References: <20090127001708.GA4815@nowhere>
	<20090126163015.7f879b18@infradead.org>
	<20090131180347.GC5884@nowhere>
	<20090131101502.7ce8e7af@infradead.org>
	<20090131182843.GD5884@nowhere>
	<1233524261.18767.60.camel@pasglop>
	<20090201211909.37c0780b@infradead.org>
	<4986B684.5000506@s5r6.in-berlin.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009 10:01:56 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Arjan van de Ven wrote:
> > On Mon, 02 Feb 2009 08:37:41 +1100
> > Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >> That's were thread pools kick in ... tried using Dave Howells slow
> >> work ?
> > 
> > async function calls are pretty much the same and actually in
> > mainlinme. Dave Howells stuff in addition plays some extremely
> > weird refcounting games that I cannot imagine anyone but him
> > needing...
> 
> I haven't looked at this particular slow-work implementation.  Do you
> refer to some internal refcounting or to some refcounting as a service
> for the API user?

the later. which I find a bit weird ;)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
