Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbXLIEEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbXLIEEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 23:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXLIEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 23:04:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbXLIEEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 23:04:45 -0500
Date: Sat, 8 Dec 2007 20:04:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
Message-Id: <20071208200415.611afb57.akpm@linux-foundation.org>
In-Reply-To: <1197169375.7352.4.camel@localhost>
References: <1197059904.15428.15.camel@localhost>
	<20071207150251.a0dbae23.akpm@linux-foundation.org>
	<1197068983.15428.29.camel@localhost>
	<20071207152249.360af326.akpm@linux-foundation.org>
	<1197090093.7157.2.camel@localhost>
	<20071208020722.9c7d91d0.akpm@linux-foundation.org>
	<1197169375.7352.4.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Dec 2007 20:02:54 -0700 Zan Lynx <zlynx@acm.org> wrote:

> 
> On Sat, 2007-12-08 at 02:07 -0800, Andrew Morton wrote:
> > On Fri, 07 Dec 2007 22:01:33 -0700 Zan Lynx <zlynx@acm.org> wrote:
> > 
> > > 
> > > On Fri, 2007-12-07 at 15:22 -0800, Andrew Morton wrote:
> > > > On Fri, 07 Dec 2007 23:09:43 +0000
> > > > Zan Lynx <zlynx@acm.org> wrote:
> > > [cut] 
> > > > > > > Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, but I
> > > > > > > only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I got
> > > > > > > at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
> > > > > > > reader.
> [cut]
> > argh.  OK.  And Linus's current tree is OK, yes?
> > 
> > In which case we should be OK for 2.6.24 and I guess we can hope like heck
> > that the dud patch doesn't leak into mainline.  Hopefully Alan will get
> > some time to look into it before 2.6.25 opens.
> 
> Linus' tree is also broken.
> 
> I tried a Linus 2.6.24-rc4 and it acts the same way, with a very slow
> transfer rate.  

shit

> I also tried 2.6.24-rc4 with the older not-libata PATA drivers and it is
> broken.

squared.

>  dmesg had a line about the CF card detected as hda,
> but /sys/block did not have hda and /dev/hda did not function.

But these drivers did work in earlier kernels, yes? 2.6.20 worked, but
we don't know about intervening kernels.

Can you tell us which version(s)?

> I will try the patches you mentioned

Yes, that won't tell use anything.

> but I think I may also have to
> work backward through kernel versions until I find the last one where
> the PCMCIA hd{a,b,c,d,e} drivers worked.

That would be great - a git-bisect is often ideal. 
http://www.kernel.org/doc/local/git-quick.html has details.


