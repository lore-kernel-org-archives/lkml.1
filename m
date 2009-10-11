Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbZJKLFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbZJKLFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 07:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZJKLFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 07:05:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:37592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbZJKLFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 07:05:04 -0400
Subject: Re: make mrproper not resetting kernel saved arch
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Dooks <ben@fluff.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20091010221736.GB7793@fluff.org.uk>
References: <20091010212505.GA7793@fluff.org.uk>
	 <20091010221736.GB7793@fluff.org.uk>
Content-Type: text/plain
Date: Sun, 11 Oct 2009 13:04:24 +0200
Message-Id: <1255259064.8967.178.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 23:17 +0100, Ben Dooks wrote:
> On Sat, Oct 10, 2009 at 10:25:05PM +0100, Ben Dooks wrote:
> > Having accidentally configured for the wrong arch, I tried going back to ARM
> > but got the following errro:
> > 
> > Makefile:210: *** ARCH changed from "x86_64" to "arm". Use "make mrproper" to fix it up.  Stop.
> > 
> > Trying to do 'make mrproper' repeats the error:
> > 
> > $ make mrproper
> > Makefile:210: *** ARCH changed from "x86_64" to "arm". Use "make mrproper" to fix it up.  Stop.
> > 
> > I ended up doing 'rm -r include/generated' to get rid of this.
> > 
> > My makefile understanding isn't good enough to repair this, so can someone
> > please fix this.
> 
> Add changing cross compiler to this list.

Yeah 575543347b5baed0ca927cb90ba8807396fe9cc9 is utterly annoying and is
breaking build scripts all over the planet.

All because people don't know how to use their shell.

