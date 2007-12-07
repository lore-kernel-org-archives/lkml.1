Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXLGAnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXLGAnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXLGAnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:43:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbXLGAnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:43:14 -0500
Date: Thu, 6 Dec 2007 16:42:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Marco Gatti <marco@pianoinflames.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug: get EXT3-fs error Allocating block in system zone
In-Reply-To: <20071206162500.1f76a234.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712061631510.13796@woody.linux-foundation.org>
References: <4755BEA1.4090604@pianoinflames.de> <20071206162500.1f76a234.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Dec 2007, Andrew Morton wrote:
> 
> http://bugs.gentoo.org/attachment.cgi?id=135761&action=view
> 
> It disables PCI BARs during sizing.  ISTR Linus opining that this was the
> wrong thing to do?

It looks ok now that it doesn't do it for host controllers. I guess we 
could just apply it.

> ISTR him having opinions on mmconfig too ;)

That piece of unbelievable crap? Have I ever said anything negative about 
something that shitty? I can't imagine having ever badmouthed such a 
mindless and totally broken piece of sh*t hardware/firmware interface.

> We should not require people to use obscure boot options to get their
> machines working.

Arjan swears he'll have a patch for me to only use mmconfig when actually 
appropriate by 2.6.25. In the meantime, the BAR disable is probably worth 
trying.

But the disk errors are something else, doesn't ring a bell. Sounds like 
IO corruption on the group descriptor block or something like that. Might 
be worth testing to see if the problem goes away with less than 4GB of 
RAM..

		Linus
