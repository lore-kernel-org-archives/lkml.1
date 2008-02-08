Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYBHX0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYBHX0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYBHXZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:25:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:52219 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751401AbYBHXZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:25:52 -0500
Date: Sat, 9 Feb 2008 00:25:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Chris Holvenstot <cholvenstot@comcast.net>,
       Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <Pine.LNX.4.64.0802081606320.30955@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0802090024190.30955@jikos.suse.cz>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
  <1202381094.6179.0.camel@popeye>  <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
  <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de> 
 <1202396868.6087.8.camel@popeye>  <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
 <1202402704.6087.12.camel@popeye> <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de>
 <Pine.LNX.4.64.0802081606320.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Jiri Kosina wrote:

> > > I hope that, from at least my perspective, your question is 
> > > rhetorical.
> > Yeah. The non rhetorical one was directed to Jiri. :)
> Actually, I have no idea :) I am right now confused too, I am quite 
> surprised that 'nohpet' fixes the problem for you, Chris, even though your 
> system doesn't have HPET at all :)
> Could you please double-check that 'nohpet' really reliably fixes the 
> issue?
> I suggested using nohpet as I have already seen reports about such kinds 
> of problems on machines that had hpet, but this one seems to be more 
> confusing :)
> Also, output of the kernel with the patch Thomas provided would be 
> interesting.

And of course I forgot to mention -- if this started happening only 
recently, and wasn't hapenning with older kernels, doing git-bisect might 
help here (assuming that are able to see whether the problem is present or 
not) to find the exact commit that causes the behavior you are seeing.

-- 
Jiri Kosina
SUSE Labs
