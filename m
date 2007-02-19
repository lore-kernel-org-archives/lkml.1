Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbXBSAhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbXBSAhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXBSAhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:37:52 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:10064 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbXBSAhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:37:51 -0500
Date: Sun, 18 Feb 2007 16:37:48 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
In-reply-to: <200702182253.10423.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <Pine.LNX.4.64.0702181636420.26450@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
 <20070216102206.343e0b0d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
 <200702182253.10423.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007, Andi Kleen wrote:

> On Saturday 17 February 2007 09:35, Zwane Mwaikambo wrote:
> > On Fri, 16 Feb 2007, Andrew Morton wrote:
> > 
> > > On Fri, 16 Feb 2007 06:39:45 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:
> > > 
> > > > On Thu, 15 Feb 2007, Andrew Morton wrote:
> > > > 
> > > > > It's not an X problem - the screen is black immediately upon loading the
> > > > > kernel.
> > > > > 
> > > > > But I guess you knew that and you're just after display info:
> > > > > http://userweb.kernel.org/~akpm/Xorg.0.log.txt
> > > > 
> > > > Thanks, the X log told me your VBE version. I tried to reproduce it on my 
> > > > thinkpad which seems to have a very similar video setup to no avail, Could 
> > > > you test the following on the VAIO? If this isn't the case, i suspect i'm 
> > > > corrupting your modelist.
> > > 
> > > It's still all black.
> > 
> > Ok it looks like i was corrupting the modelist. The following should take 
> > care of your VAIO, but i haven't tested the failure case as Tobias is away 
> > this weekend.
> 
> I merged this version of the patch now. Still needs some x86-64 testing
> I guess (any volunteers?), although I don't expect much trouble
> because the early boot code is very similar.

I tested the x86_64 VBE3 case (similar to Andrew's VAIO), so we just need 
a VBE1.2 on x86_64 test.

Thanks,
	Zwane

