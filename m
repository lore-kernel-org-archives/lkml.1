Return-Path: <linux-kernel-owner+w=401wt.eu-S933218AbZKXPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbZKXPFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbZKXPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:05:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040AbZKXPFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:05:18 -0500
Date: Tue, 24 Nov 2009 16:05:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: cannot compile linux-2.6-tip tree
Message-ID: <20091124150510.GE1975@jolsa.lab.eng.brq.redhat.com>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
 <1259074361.22249.1069.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259074361.22249.1069.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:52:41AM -0500, Steven Rostedt wrote:
> On Tue, 2009-11-24 at 13:41 +0100, Jiri Olsa wrote:
> 
> > [jolsa@jolsa linux-2.6-tip]$ git checkout -b test-bad 2e7c0e0cafee5f04a029f06e71e22f9af69ae472
> > Switched to a new branch 'test-bad'
> > [jolsa@jolsa linux-2.6-tip]$ find drivers/pnp/ -name *.o | xargs rm
> > [jolsa@jolsa linux-2.6-tip]$ make drivers/pnp/
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   SYMLINK include/asm -> include/asm-x86
> >   CC      arch/x86/kernel/asm-offsets.s
> >   GEN     include/asm/asm-offsets.h
> >   CALL    scripts/checksyscalls.sh
> >   CC      drivers/pnp/core.o
> >   CC      drivers/pnp/card.o
> > objdump: drivers/pnp/.tmp_card.o: File truncated
> > nm: drivers/pnp/card.o: File truncated
> > objdump: drivers/pnp/card.o: File truncated
> 
> 
> That's a strange error. Are you sure you didn't run out of diskspace or
> something?

you cannot reproduce, too bad :) I'll dive into and try to find out..

disk space is fine, also checkouts before the bisected commit work fine
let me know if you're interested in any debug info, I'll provide

jirka

> 
> -- Steve
> 
> >   CC      drivers/pnp/driver.o
> >   CC      drivers/pnp/resource.o
> >   CC      drivers/pnp/manager.o
> >   CC      drivers/pnp/support.o
> >   CC      drivers/pnp/interface.o
> >   CC      drivers/pnp/quirks.o
> >   CC      drivers/pnp/pnpacpi/core.o
> >   CC      drivers/pnp/pnpacpi/rsparser.o
> >   LD      drivers/pnp/pnpacpi/built-in.o
> >   CC      drivers/pnp/system.o
> >   LD      drivers/pnp/built-in.o
> > drivers/pnp/card.o: file not recognized: File format not recognized
> > make[1]: *** [drivers/pnp/built-in.o] Error 1
> > make: *** [drivers/pnp/] Error 2
> > [jolsa@jolsa linux-2.6-tip]$ 
> > 
> 
> 
