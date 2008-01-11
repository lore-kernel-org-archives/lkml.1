Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbYAKWDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbYAKWDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761730AbYAKWC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:02:58 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:44443 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761065AbYAKWC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:02:57 -0500
Date: Fri, 11 Jan 2008 17:01:43 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
	traditional
Message-ID: <20080111220142.GA6751@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org
References: <20080109220508.686bbda4@laptopd505.fenrus.org> <alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org> <20080110203519.573567b7@laptopd505.fenrus.org> <alpine.LFD.1.00.0801111136520.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801111136520.3148@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:41:40AM -0800, Linus Torvalds wrote:
> 
> (I also wonder if we should limit the number of entries we print out. 
> Sometimes the stack frame ends up being so deep that we lose the 
> *important* stuff. I think it might be good idea to have some rule like 
> "the first 5 entries go to the screen, the rest will be KERN_DEBUG and 
> only go to the logs by default" - so a "dmesg" would show it all, but if 
> the machine is hung, the screen won't have been scrolled away from all 
> the other things by a long backtrace!)

What might be useful is the first 5 and last 5.  Sometimes if you have
a very deep call chain, the what was the original system call or
interrupt which got the kernel deep into la-la land can often be
useful.  Just a thought.

					- Ted
