Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab0CFXrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 18:47:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab0CFXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 18:46:58 -0500
Date: Sat, 6 Mar 2010 15:46:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH 0/2] Make functions of dev_<level> macros, recursive
 vsnprintf
In-Reply-To: <1267918554.849.89.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.00.1003061540470.23804@localhost.localdomain>
References: <cover.1267682641.git.joe@perches.com>  <20100304143837.af39845d.akpm@linux-foundation.org>  <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>  <1267911399.849.39.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
  <1267914654.849.81.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>  <alpine.LFD.2.00.1003061455590.31447@localhost.localdomain> <1267918554.849.89.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Joe Perches wrote:
> 
> I believe 32 bits isn't possible.
> 
> type:6
> flags:8
> width:8
> base:6
> precision:6
> qualifier:8

type: 5
flags: 7
width: 5 (make it 6 bits and signed)
base: 5
precision: 5 (make it 6 bits, and signed)
qualifier: 3

Now, admittedly, right now 'qualifier' really has to be 8, but that's just 
because we use an ASCII character for it. But I don't think there are more 
than 8 actual legal qualifiers. And 'base' could be just 2 bits, since 
there are only a couple of legal bases, but I left room for them all 
anyway.

And the other really should fit in those numbers unchanged, I think. 

			Linus
