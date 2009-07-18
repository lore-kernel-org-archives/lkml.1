Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZGRAuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZGRAuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 20:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZGRAuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 20:50:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbZGRAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 20:50:18 -0400
Date: Fri, 17 Jul 2009 17:48:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rgetz@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] kernel.printk.c - ensure that "console enabled"
 messages are printed on the console
Message-Id: <20090717174852.c00aa374.akpm@linux-foundation.org>
In-Reply-To: <20090710102547.GD5499@elte.hu>
References: <200907040017.26921.rgetz@blackfin.uclinux.org>
	<200907091308.37370.rgetz@blackfin.uclinux.org>
	<20090710102547.GD5499@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 12:25:47 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > Today, when a console is registered without CON_PRINTBUFFER, end 
> > users never see the announcement of it being added, and never know 
> > if they missed something, if the console is really at the start or 
> > not, and just leads to general confusion.
> > 
> > This re-orders existing code, to make sure the console is added, 
> > before the "console [%s%d] enabled" is printed out - ensuring that 
> > this message is _always_ seen.
> > 
> > This has the desired/intended side effect of making sure that 
> > "console enabled:" messages are printed on the bootconsole, and 
> > the real console. This does cause the same line is printed twice 
> > if the bootconsole and real console are the same device, but if 
> > they are on different devices, the message is printed to both 
> > consoles.
> > 
> > Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > ---
> > 
> >  printk.c |   44 +++++++++++++++++++++++++++++---------------
> >  1 file changed, 29 insertions(+), 15 deletions(-)
> > 
> > patch generated for -tip
> 
> Looks good, applied it to tip:core/printk for v2.6.32, thanks Robin. 
> 

Seven days later, this isn't in linux-next.  Did it get lost?
