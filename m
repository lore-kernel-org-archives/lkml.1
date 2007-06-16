Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXFPGcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXFPGcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 02:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXFPGcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 02:32:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbXFPGcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 02:32:42 -0400
Date: Fri, 15 Jun 2007 23:31:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
Subject: Re: Jinxed VAIO wreckage - current state of affairs
Message-Id: <20070615233138.78a79b00.akpm@linux-foundation.org>
In-Reply-To: <1181921466.8176.356.camel@chaos>
References: <1181418873.4404.402.camel@chaos>
	<200706092259.50694.rjw@sisk.pl>
	<20070609200827.635fec79.akpm@linux-foundation.org>
	<1181909157.8176.342.camel@chaos>
	<20070615082324.203610ec.randy.dunlap@oracle.com>
	<1181921466.8176.356.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 17:31:06 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 2007-06-15 at 08:23 -0700, Randy Dunlap wrote:
> > On Fri, 15 Jun 2007 14:05:57 +0200 Thomas Gleixner wrote:
> > 
> > > On Sat, 2007-06-09 at 20:08 -0700, Andrew Morton wrote:
> > > > On Sat, 9 Jun 2007 22:59:49 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > 
> > > > > Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?
> > > > 
> > > > People would have heard if it was busted ;)
> > > 
> > > Just found a brown paperbag bug in the resume patch logic. Sigh, I was
> > > staring at that code for month without noticing.
> > > 
> > > Andrew,
> > > 
> > > can you please test
> > > 
> > > http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt9.patch
> > 
> > bad URL, not found.
> 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt10.patch
> 

That suspends and resumes OK.

What was the bug?
