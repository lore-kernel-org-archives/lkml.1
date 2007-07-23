Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXGWQzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXGWQzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXGWQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:55:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbXGWQzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:55:39 -0400
Date: Mon, 23 Jul 2007 09:55:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jan Engelhardt <jengelh@computergmbh.de>, Paul Mundt <lethal@linux-sh.org>,
       Jon Smirl <jonsmirl@gmail.com>, Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git tree for old kernels from before the current tree
In-Reply-To: <46A3D5EA.2050600@zytor.com>
Message-ID: <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org>
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
 <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
 <20070722211314.GA13850@linux-sh.org> <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr>
 <46A3D5EA.2050600@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Jul 2007, H. Peter Anvin wrote:
> 
> Wouldn't be hard to make a git tree with all the patches all the way
> back to 0.01 even...

I actually tried to get something like this together back in the BK days 
and early in the SCO saga. It was pretty painful to try to find all the 
historic trees and patches - they're all in different format, and some of 
them are unreliable (ie CVS imports by people like Ted).

The good news is that git would be a lot more natural to the process of 
trying to create a history, because you could basically import random 
trees, and tag them as just independent trees, and then re-create the 
history after-the-fact by trying to stitch them all together. And if you 
find a new tree, you'd just re-stitch it - something that was very hard to 
do with BK (and BK generally wouldn't help you with keeping multiple 
independent trees around, and wouldn't generally accept the notion of 
re-doing the histories and keeping various versions of the histories 
around).

So I've been thinking about trying to re-create some really old history 
into git, but it's still a lot of work.. And obviously not very useful, 
just interesting from an archeological standpoint.

			Linus
