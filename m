Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZBASLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZBASLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 13:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZBASLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 13:11:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:60220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZBASLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 13:11:40 -0500
Date: Sun, 1 Feb 2009 10:11:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090201101140.554995b7@infradead.org>
In-Reply-To: <4985E4B8.5020100@s5r6.in-berlin.de>
References: <20090127001708.GA4815@nowhere>
	<20090126163015.7f879b18@infradead.org>
	<20090131180347.GC5884@nowhere>
	<20090131101502.7ce8e7af@infradead.org>
	<20090131182843.GD5884@nowhere>
	<4985CC57.7090800@s5r6.in-berlin.de>
	<20090201090429.0c7e1362@infradead.org>
	<4985DE82.5030208@s5r6.in-berlin.de>
	<20090201094727.4615305c@infradead.org>
	<4985E4B8.5020100@s5r6.in-berlin.de>
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

On Sun, 01 Feb 2009 19:06:48 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Arjan van de Ven wrote:
> > On Sun, 01 Feb 2009 18:40:18 +0100
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> I don't see the "async/mgr" in the process list of that
> >> 2.6.29-rc3 box next to me.  Under which circumstances is this
> >> facility available (long after boot)?  Or am I just barging into a
> >> discussion to /make/ it available after boot?
> > 
> > for 2.6.29 only it was turned off by default, for 2.6.30 it will be
> > on by default.
> 
> Ah right, I forgot.  Thanks for the pointers,

you can get it right now by just putting "fastboot" on the kernel
commandline.

btw what you're describing looks like a good fit; that's good news ;)
if you need any help or have questions just let me know


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
