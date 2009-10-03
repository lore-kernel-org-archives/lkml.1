Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZJCQhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZJCQhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZJCQhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:37:23 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:52871 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZJCQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:37:22 -0400
Date: Sat, 3 Oct 2009 19:36:45 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: ftrace WARNING during boot
Message-ID: <20091003163645.GI32486@mea-ext.zmailer.org>
References: <20091003105318.GB32486@mea-ext.zmailer.org> <20091003110002.GA6162@nowhere> <20091003112850.GC32486@mea-ext.zmailer.org> <1254585561.12892.3.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254585561.12892.3.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 11:59:21AM -0400, Steven Rostedt wrote:
> On Sat, 2009-10-03 at 14:28 +0300, Matti Aarnio wrote:
> 
....
> > > >  kernel: ---[ end trace fbf9054ae0f212c7 ]---
> > > >  kernel: ftrace faulted on writing [<ffffffffa0003072>] i2c_new_dummy+0x8/0x5e [i2c_core]
> 
> This means the update to modify the call to mcount to a nop failed.
> Everything else passed (the read and compare). I think I saw some
> patches go by that works on making the text in modules read only.
> 
> The ftrace update for text in core kernel makes the text writable for
> the small window where we call kstop machine and update the text. Then
> it makes that code read only again. At the time this code was written,
> the modules were always read/write. If this has changed, I believe the
> ftrace update needs to be fixed too.

Lattest kernel on Fedora 12 beta series does not have this trouble.
(It has troubles elsewere, but not at ftrace.)

  ACPI: Core revision 20090521
  ftrace: converting mcount calls to 0f 1f 44 00 00
  ftrace: allocating 21030 entries in 83 pages
  Setting APIC routing to flat

> -- Steve

/Matti Aarnio
