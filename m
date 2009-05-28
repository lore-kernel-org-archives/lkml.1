Return-Path: <linux-kernel-owner+w=401wt.eu-S1765006AbZE1Uuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765006AbZE1Uuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764961AbZE1UuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:50:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50597 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764901AbZE1UuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:50:13 -0400
Date: Thu, 28 May 2009 22:50:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090528205008.GF11477@elf.ucw.cz>
References: <200905221139.26941.lkml@morethan.org> <200905221721.08495.lkml@morethan.org> <20090528124853.GC1421@ucw.cz> <200905280829.15672.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905280829.15672.lkml@morethan.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-28 08:29:13, Michael S. Zick wrote:
> On Thu May 28 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > The observation that executing an unnecessary 'lock' opcode in some
> > > cases slows down the machine is not felt by myself to be significant 
> > > to duplicating my observations.  Note: I have been wrong before.
> > > 
> > > This is as informative as I can make the message.
> > > 
> > > PS: *not* a single machine failure, tested on five machines, owned
> > > by four different people, two brands, with different use histories.
> > 
> > I have seen some problems on via c7m based machines, where some 'smart
> > bios person' implemented EC access in AML (normally, it is accessed
> > from ec.c driver). Maybe you have similary bad bios?
> > 
> 
> How to tell or distingush?
> Did your looking at the dmidecode output show you that?

Disassemble DSDT, and if you see strange code duplicating kernel's
ec.c driver, you have similar problem... 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
