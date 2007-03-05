Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbXCEC3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbXCEC3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXCEC3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:29:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbXCEC3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:29:36 -0500
Date: Sun, 04 Mar 2007 18:29:35 -0800 (PST)
Message-Id: <20070304.182935.74729828.davem@davemloft.net>
To: bunk@stusta.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, vonbrand@inf.utfsm.cl,
       davem@sunset.davemloft.net, sparclinux@vger.kernel.org
Subject: Re: [6/6] 2.6.21-rc2: known regressions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070305022602.GL3441@stusta.de>
References: <20070305015045.GK3441@stusta.de>
	<20070304.180725.126592830.davem@davemloft.net>
	<20070305022602.GL3441@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 5 Mar 2007 03:26:02 +0100

> On Sun, Mar 04, 2007 at 06:07:25PM -0800, David Miller wrote:
> > From: Adrian Bunk <bunk@stusta.de>
> > Date: Mon, 5 Mar 2007 02:50:45 +0100
> > 
> > > Subject    : sparc64 compile error due to GENERIC_ISA_DMA removal
> > > References : http://bugzilla.kernel.org/show_bug.cgi?id=8097
> > > Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
> > > Caused-By  : David S. Miller <davem@sunset.davemloft.net>
> > >              commit 1b51d3a08b6c80a1e47d4c579c41abbe56cd3c44
> > > Status     : unknown
> > 
> > Fixed in current GIT.
> > 
> > commit 74bd7d093b8e87f35eaf3b14459b96a0e20d1d10
> > Author: David S. Miller <davem@sunset.davemloft.net>
> > Date:   Wed Feb 28 13:09:34 2007 -0800
> > 
> >     [SPARC64]: Fix parport_pc build.
> >     
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Horst's problem is with the floppy driver and 
> claim_dma_lock/release_dma_lock in include/asm-sparc64/dma.h .

Thanks for the clarification, I was thinking of the parport
problem reported by Meelis Roos.

I'll look into this.
