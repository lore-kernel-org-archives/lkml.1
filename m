Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab0BDTMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:12:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757891Ab0BDTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:12:52 -0500
Date: Thu, 4 Feb 2010 11:11:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sven Joachim <svenjoac@gmx.de>
cc: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
In-Reply-To: <87sk9gbzzt.fsf@turtle.gmx.de>
Message-ID: <alpine.LFD.2.00.1002041102530.3707@localhost.localdomain>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Sven Joachim wrote:
> 
> It seems they are all there, but on my system with 64-bit kernel and
> 32-bit userland, 2.6.32.8-rc1 still panics in the way noticed by Ben.

Ok. Greg - please skip these patches from stable for now. I'll try to 
figure out what's up.

Sven/Ben: is /sbin/init (or wherever debian puts it) a regular ELF file? 
Shared libraries? Anything at all special about it? I wonder why it seems 
to have issues, when other 32-bit programs don't.

Of course, it's entirely possible that other Debian 32-bit programs do 
not, but I haven't heard about problems with (for example) firefox from 
people who run 64-bit distros but with a 32-bit browser (which at least 
used to be very common due to the whole flash plugin issue). So I wonder 
if there is soemthing special about init.

		Linus
