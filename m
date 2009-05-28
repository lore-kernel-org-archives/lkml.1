Return-Path: <linux-kernel-owner+w=401wt.eu-S1763080AbZE1VQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763080AbZE1VQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760102AbZE1VQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:16:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33676 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbZE1VQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:16:36 -0400
Date: Thu, 28 May 2009 23:16:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090528211632.GH11477@elf.ucw.cz>
References: <200905221139.26941.lkml@morethan.org> <200905280829.15672.lkml@morethan.org> <20090528205008.GF11477@elf.ucw.cz> <200905281559.00652.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905281559.00652.lkml@morethan.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > I have seen some problems on via c7m based machines, where some 'smart
> > > > bios person' implemented EC access in AML (normally, it is accessed
> > > > from ec.c driver). Maybe you have similary bad bios?
> > > 
> > > How to tell or distingush?
> > > Did your looking at the dmidecode output show you that?
> > 
> > Disassemble DSDT, and if you see strange code duplicating kernel's
> > ec.c driver, you have similar problem... 
> 
> Someone did that but wasn't looking for "strange code" - just fixing
> some entry size errors.
> You can find the replacement DSDT here:
> http://forum.netbookuser.com/viewtopic.php?pid=6512#p6512
> 
> (Which I am not using, since it mostly cosmetic.)

Ok, it does not seem to have braindead EC implementation. The DSDT
does not look familiar, so it may be different issue. (Or it is same
issue and we were not able to debug it due to all the BIOS problems.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
