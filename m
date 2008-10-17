Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYJQXDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYJQXDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbYJQXDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:03:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:36271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbYJQXDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:03:42 -0400
Date: Fri, 17 Oct 2008 16:00:11 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081017230011.GA14185@suse.de>
References: <20081017220027.GA3659@kroah.com> <alpine.LFD.2.00.0810171544320.3438@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0810171544320.3438@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 03:47:58PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 17 Oct 2008, Greg KH wrote:
> >
> > Here is the big batch of USB patches for your 2.6-git tree.
> 
> I really wish I were to get the occasional _clean_ pull for a change.
> 
> f*ck me, but why do people keep adding more and more warnings, and 
> apparently not even bother to write clean code? The merge window is no 
> excuse for badly written crap.
> 
>   drivers/usb/host/ehci-hcd.c: In function ‘ehci_hcd_init’:
>   drivers/usb/host/ehci-hcd.c:1115: warning: label ‘err_debug’ defined but not used

Why am I not seeing that warning here?

ah, because I have debugging for USB enabled in my configuration, sorry
about that, I should have caught that.  That's the problem with doing a
'make allyesconfig' as a test build, I need to make it random at times
to catch things like this.

> That particular function is just about the ugliest thing I've ever seen, 
> and now it's adding annoying warnings too!

I agree, it's always been ugly, sorry for making it worse.  I'll move
that label up one line and fix the warning.

thanks,

greg k-h
