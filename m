Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbYDQNie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbYDQNie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYDQNi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:38:26 -0400
Received: from www.tglx.de ([62.245.132.106]:56508 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYDQNi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:38:26 -0400
Date: Thu, 17 Apr 2008 15:38:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Dubov <oakad@yahoo.com>
cc: Ben Dooks <ben@fluff.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
In-Reply-To: <257448.48285.qm@web36701.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0804171535581.3261@apollo.tec.linutronix.de>
References: <257448.48285.qm@web36701.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Alex Dubov wrote:
> --- Ben Dooks <ben@fluff.org> wrote:
> 
> > On Thu, Apr 17, 2008 at 01:50:33AM -0700, Alex Dubov wrote:
> > > I've implemented, with generous help from JMicron, a native support for Smartmedia/xD picture
> > card
> > > media. Currently, only JMicron backend is available, but TI expressed some interest in this
> > too,
> > > so TI Flashmedia backend may soon follow.
> > > 
> > > Smartmedia cards are quite akin to the dumb flash chips, but they have their quirks that put
> > them
> > > aside as a separate media type.
> > 
> > They're NAND chips, just with a standard ECC/block replacement
> > stratergy... why isn't this under drivers/mtd ?
> > 
> 
> They have nothing to do with JFFS or UBI (it's an interchange
> format).  They require FTL. 

MTD is independent of JFFS2 and UBI. It's the hardware abtraction
layer on which you build an FTL.

> On the other hand, "SmartMedia reader"
> is a rather definite kind of animal that exists on its own.

No it is not. SmardMedia is a bare NAND chip, which is already covered
by MTD. There are already other FTLs on top of MTD and the SmartMedia
format just can be added to those.

Thanks,
	tglx

