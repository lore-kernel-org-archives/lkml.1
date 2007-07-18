Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbXGRUl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbXGRUl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXGRUlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:41:20 -0400
Received: from waste.org ([66.93.16.53]:54427 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbXGRUlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:41:19 -0400
Date: Wed, 18 Jul 2007 15:41:02 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718204102.GM11115@waste.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718201043.GF3898@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 10:10:43PM +0200, Andi Kleen wrote:
> 
> I was waiting for someone to make that "point" ...
> 
> > 
> > Every byte you can shave off the compressed kernel image is another
> > byte you can use for userspace on your FLASH.
> 
> Now let's see if that 1MB 386 contains any flash at all. Guesses?  

I've certainly worked on such devices. I expect there are more of them
still in service, than, say, Voyagers.

I haven't looked at whether this CPUID stuff is worth the trouble, I'm
just responding to your argument about init code. Init code is
definitely not free. It takes up storage space, which can be extremely
valuable.

The deeper point is: if you know what your platform is, platform
feature detection is a waste of code, regardless of whether it's
marked init or not.

-- 
Mathematics is the supreme nostalgia of our time.
