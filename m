Return-Path: <linux-kernel-owner+w=401wt.eu-S932677AbYBTT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbYBTT12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYBTT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:27:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbYBTT1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:27:16 -0500
Date: Wed, 20 Feb 2008 11:26:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080220112655.18011dab@laptopd505.fenrus.org>
In-Reply-To: <1203533622.6243.55.camel@lappy>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<1203531375.6243.52.camel@lappy>
	<20080220103940.0a0b5ce0@laptopd505.fenrus.org>
	<1203533622.6243.55.camel@lappy>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 19:53:42 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Wed, 2008-02-20 at 10:39 -0800, Arjan van de Ven wrote:
> > On Wed, 20 Feb 2008 19:16:15 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > 
> > > On Tue, 2008-02-19 at 12:37 -0800, Arjan van de Ven wrote:
> > > > From: Soren Sandmann <sandmann@redhat.com>
> > > > Subject: [PATCH] x86: add the debugfs interface for the sysprof
> > > > tool
> > > > 
> > > > The sysprof tool is a very easy to use GUI tool to find out
> > > > where userspace is spending CPU time. See
> > > > http://www.daimi.au.dk/~sandmann/sysprof/
> > > > for more information and screenshots on this tool.
> > > > 
> > > > Sysprof needs a 200 line kernel module to do it's work, this
> > > > module puts some simple profiling data into debugfs.
> > > 
> > > What is the added value over oprofile?
> > 
> > it actually works and is usable by humans ;)
> 
> # sysprof
> 
> (sysprof:12480): Gtk-WARNING **: cannot open display:
> 
> -ENOX
> 
> > what oprofile doesn't do is the nice userland hierarchy of where
> > cpu time is spend. (and that is also what makes it mostly useless
> > in practice)
> 
> so why not fix oprofile callgraph output and build a GUI on top of
> oprofile for those of us who really want RSI from mouse movement :-)

feel free to reinvent a whole GUI just to avoid a 200 line kernel module.
sysprof is here. it works. the gui is REALLY nice.
I think it's the wrong tradeoff though... oprofile exists for how long?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
