Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYAIELt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYAIELt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYAIELl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:11:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYAIELk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:11:40 -0500
Date: Tue, 8 Jan 2008 20:10:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Matthew Wilcox <matthew@wil.cx>, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-Id: <20080108201042.03c3aead.akpm@linux-foundation.org>
In-Reply-To: <8336.1199851267@turing-police.cc.vt.edu>
References: <20080106171158.GM20473@parisc-linux.org>
	<1199640983.5205.65.camel@localhost.localdomain>
	<20080106183402.GA7906@1wt.eu>
	<20080106185625.GM2082@does.not.exist>
	<20080106191044.GA1105@1wt.eu>
	<20080106195802.GN2082@does.not.exist>
	<20080106210813.GA10136@1wt.eu>
	<19438.1199739038@turing-police.cc.vt.edu>
	<20080107213717.GB16309@parisc-linux.org>
	<26581.1199747065@turing-police.cc.vt.edu>
	<20080107231930.GC16309@parisc-linux.org>
	<8336.1199851267@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 23:01:07 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Mon, 07 Jan 2008 16:19:30 MST, Matthew Wilcox said:
> > On Mon, Jan 07, 2008 at 06:04:25PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > > Theoretically, at least.  Sometimes, in the real world, other constraints
> > > enter into it...
> > 
> > So you're saying that you can't find reliable ways to reproduce problems
> > on demand?  Those are some of the lower quality bug reports, so I don't
> > think we're losing much by having you not report them.
> 
> I'm sure that *everybody* on this list would *love* to know how you find
> a reliable way to reproduce all the bugs that start off with "after X days of
> uptime".   But when you're chasing what might be a race condition with a
> very small timing hole, you may need an event to happen several million times
> before the accumulated chance of hitting it becomes appreciable.
> 

I must say that the number of bugs which actually go away when the user
stops using nvidia/fglrx/ndiswrapper/etc is a small minority.

And you can usually tell beforehand too: if the user reports bad_page
warnings or pte table scroggage or whatever and they're using nvidia I just
hit 'd'.  But people who think that removing the nvidia driver will
magically fix that khubd-got-stuck-in-D-state bug are urinating up an
incline.


Facts:

- lots of people use nvidia/etc

- most bugs they report aren't caused by nvidia/etc

- we need lots of testers

draw you own conclusions.
