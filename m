Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZEBQax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZEBQax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 12:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbZEBQah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 12:30:37 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45563 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbZEBQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 12:30:36 -0400
Date: Sat, 2 May 2009 18:32:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 0/5] section name cleanup for parisc
Message-ID: <20090502163235.GA2423@uranus.ravnborg.org>
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu> <20090502141953.GC28342@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502141953.GC28342@bombadil.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 10:19:53AM -0400, Kyle McMartin wrote:
> On Thu, Apr 30, 2009 at 07:55:14PM -0400, Tim Abbott wrote:
> > This patch series cleans up the section names on the parisc
> > architecture.  It requires the architecture-independent macro
> > definitions from this patch series:
> > 
> > <http://www.spinics.net/lists/mips/msg33499.html>
> > 
> > The long-term goal here is to add support for building the kernel with
> > -ffunction-sections -fdata-sections.  This requires renaming all the
> > magic section names in the kernel of the form .text.foo, .data.foo,
> > .bss.foo, and .rodata.foo to not have collisions with sections
> > generated for code like:
> > 
> > static int nosave = 0; /* -fdata-sections places in .data.nosave */
> > static void head(); /* -ffunction-sections places in .text.head */
> > 
> > Note that these patches have not been boot-tested (aside from testing
> > the analogous changes on x86), since I don't have access to the
> > appropriate hardware.
> > 
> > 	-Tim Abbott
> > 
> > 
> > Tim Abbott (5):
> >   parisc: use NOSAVE_DATA macro for .data.nosave section.
> >   parisc: use new macro for .data.cacheline_aligned section.
> >   parisc: use new macros for .data.init_task.
> >   parisc: use new macro for .data.read_mostly section.
> >   parisc: convert to new generic read_mostly support.
> > 
> 
> Not sure what the easiest way to merge these will be... I'll apply them
> to a section-cleanup branch in the parisc git tree until the
> architecture independent portions are upstream.

I expect the parisc stuff to be redone. I'm working at the arch
independent stuff atm and will post a new patch later this weekend.
That will make the current patch obsolete.

	Sam
