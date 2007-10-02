Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbXJBKsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbXJBKsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXJBKsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:48:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:41428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbXJBKsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:48:11 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Date: Tue, 2 Oct 2007 12:48:05 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org > <200710021121.36443.ak@suse.de> <47021F83.4070609@garzik.org>
In-Reply-To: <47021F83.4070609@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021248.06050.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 12:37:55 Jeff Garzik wrote:
> Andi Kleen wrote:
> > On Tuesday 02 October 2007 11:17:02 Thomas Gleixner wrote:
> >>> This is also a good time to warn about the fact that we're doing the x86 
> >>> merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
> >>> have pending patches for the next series that touch arch/i386 or x86-64, 
> >>> you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
> >>> keepers of the merge scripts, and will help you prepare..
> > 
> > 
> > Yes I have ~100 patches for arch/x86_64, arch/i386
> > 
> > Should I just drop them?
> 
> Why don't you work with Thomas and Ingo to make sure everything is in 
> sync and prepped for 2.6.24?

The easiest way to do that would be to first merge all the queued and
collected patches from the last months. Once they are in people
can then create whatever mess they like.

The other way round  (adapting 100+ patches to a possibly completely
different tree) will be a huge amount of work which I am
frankly not very motivated to do because I think it's quite unnecessary. 

I would probably just push the work back to all the patch submitters -- that is 
what I meant with dropping the patches.

I assume mess up first would be also a minor catastrophe for Andrew --
in addition to my patches he also has a large number of patches
touching {x86_64,i386}

-Andi
