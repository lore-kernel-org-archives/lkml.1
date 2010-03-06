Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0CFX6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 18:58:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638Ab0CFX6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 18:58:36 -0500
Date: Sat, 6 Mar 2010 15:58:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH 0/2] Make functions of dev_<level> macros, recursive
 vsnprintf
In-Reply-To: <alpine.LFD.2.00.1003061547490.23804@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003061556420.23804@localhost.localdomain>
References: <cover.1267682641.git.joe@perches.com>  <20100304143837.af39845d.akpm@linux-foundation.org>  <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>  <1267911399.849.39.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
  <1267914654.849.81.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>  <alpine.LFD.2.00.1003061455590.31447@localhost.localdomain> <1267918554.849.89.camel@Joe-Laptop.home> <alpine.LFD.2.00.1003061540470.23804@localhost.localdomain>
 <alpine.LFD.2.00.1003061547490.23804@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Linus Torvalds wrote:

> 
> 
> On Sat, 6 Mar 2010, Linus Torvalds wrote:
> >
> > width: 5 (make it 6 bits and signed)
> > precision: 5 (make it 6 bits, and signed)
> 
> Oh, actually, no, we do that whole left-justification with the flags, we 
> don't need that signed stuff. We do need one special value for the "no 
> width, no precision", though.

Btw, yeah, we do have a couple of "%.100s" etc, but we could fix those if 
we really wanted to do this.

And no, I guess we don't really need to make it 32-bit. Fitting in 64 bits 
would already be a big improvement over what we have now.

				Linus
