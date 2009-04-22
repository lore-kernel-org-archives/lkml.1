Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZDVMwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZDVMwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZDVMwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:52:36 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46819 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZDVMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:52:36 -0400
Date: Wed, 22 Apr 2009 21:47:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@mit.edu>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Message-ID: <20090422124727.GA7315@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tim Abbott <tabbott@mit.edu>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Jeff Arnold <jbarnold@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jon Masters <jonathan@jonmasters.org>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain> <200904211520.57861.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904211520.57861.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 03:20:56PM +0930, Rusty Russell wrote:
> On Tue, 21 Apr 2009 09:10:58 am Linus Torvalds wrote:
> > 
> > On Mon, 20 Apr 2009, Tim Abbott wrote:
> > >
> > > Is there a problem that is preventing this -ffunction-sections patch 
> > > series from being merged?
> > 
> > Quite frankly, every time I see something like this, I shudder.
> 
> It's the section name cleanup which is the invasive part, and I'd like to
> see merged now.
> 
> I don't care so much about actually flipping the option on.
> 
There are also already architectures in-tree that default enable it
today: frv, mips, and parisc. So at least the toolchain situation seems
to be sorted well enough for some people (admittedly easier if there are
fewer toolchain variants floating about..).

It is appealing from the embedded side at least, so it's forseeable that
most of the CONFIG_EMBEDDED users will enable it purely on the size
basis, especially since the tiny people seem to be mostly grasping at
straws these days..
