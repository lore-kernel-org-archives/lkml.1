Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbZE1VVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbZE1VVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbZE1VVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:21:30 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:56991 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbZE1VV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:21:29 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Thu, 28 May 2009 16:21:12 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905281559.00652.lkml@morethan.org> <20090528211632.GH11477@elf.ucw.cz>
In-Reply-To: <20090528211632.GH11477@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905281621.15543.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu May 28 2009, Pavel Machek wrote:
> Hi!
> 
> > > > > I have seen some problems on via c7m based machines, where some 'smart
> > > > > bios person' implemented EC access in AML (normally, it is accessed
> > > > > from ec.c driver). Maybe you have similary bad bios?
> > > > 
> > > > How to tell or distingush?
> > > > Did your looking at the dmidecode output show you that?
> > > 
> > > Disassemble DSDT, and if you see strange code duplicating kernel's
> > > ec.c driver, you have similar problem... 
> > 
> > Someone did that but wasn't looking for "strange code" - just fixing
> > some entry size errors.
> > You can find the replacement DSDT here:
> > http://forum.netbookuser.com/viewtopic.php?pid=6512#p6512
> > 
> > (Which I am not using, since it mostly cosmetic.)
> 
> Ok, it does not seem to have braindead EC implementation. The DSDT
> does not look familiar, so it may be different issue. (Or it is same
> issue and we were not able to debug it due to all the BIOS problems.)
> 

Thanks for taking a look, 
it would have meant nothing to me.

Mike
> 									Pavel


