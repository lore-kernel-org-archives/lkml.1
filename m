Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYHLRSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYHLRSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYHLRSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:18:02 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:56660 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYHLRSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:18:00 -0400
Date: Tue, 12 Aug 2008 18:18:00 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive in checkpatch
Message-ID: <20080812171800.GA29207@brain>
References: <Pine.LNX.4.44L0.0808121017510.2509-100000@iolanthe.rowland.org> <m3d4kefe0x.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3d4kefe0x.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 05:29:02PM +0200, Krzysztof Halasa wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > ERROR: space prohibited after that '*' (ctx:BxW)
> 
> 
> > Certainly this is a rather uncommon code construction, but similar
> > ones might occur elsewhere.  To my eyes,
> >
> > 	(* (type *) ptr)
> >
> > looks better than
> >
> > 	(*(type *) ptr)
> >
> > or
> >
> > 	(*(type *)ptr)
> >
> > or even
> >
> > 	(*(type*)ptr)
> >
> > but of course this is a matter of opinion.  Is there any strong feeling 
> > about this in the kernel community?
> 
> I think checkpatch already has gone way too far with this (and not
> only this).
> 
> "type *var" vs "type* var" - sure, the latter is worse and provokes
> "type* var1, var2", but anything else is IMHO only annoying and,
> actually, not important WRT readability at all.
> 
> For example I prefer "type* func()" - as it's a function returning
> "a pointer to type" and not "a pointer to a function returning type"
> (which "type *func()" may suggest). Yes, func is not a pointer, so why
> write "*" next to it?

The recommendations it makes match the style of the whole, which new
contributions should follow.  To a lot of people these nuances don't
matter to others they do.  checkpatch aims to tell you what you will
likely be picked up on.  Its recommending a standardised style that is
not necessarily what any one of us would use.  But that is its role.
Feel free to ignore any of its recommendations, but expect to be pulled
up on a lot of them if you do; remembering the time of the reviewer
that is wasted in doing so.

-apw
