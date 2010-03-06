Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0CFWDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 17:03:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753506Ab0CFWDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 17:03:16 -0500
Date: Sat, 6 Mar 2010 14:03:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH 0/2] Make functions of dev_<level> macros, recursive
 vsnprintf
In-Reply-To: <1267911399.849.39.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
References: <cover.1267682641.git.joe@perches.com>  <20100304143837.af39845d.akpm@linux-foundation.org>  <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain> <1267911399.849.39.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Joe Perches wrote:
> 
> Is that an ack, a nack or a get the hell out?

It's mostly an Ack. I think the concept is great. I'd love to have some 
way to limit recursion, and I'd also love to see some actual numbers of 
how deep the vsnprintf stack frame is, but I don't see how to do the 
first, and I'm hoping the second isn't too horrible.

		Linus

