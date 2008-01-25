Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbYAYWsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbYAYWsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYAYWsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:48:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:51280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYAYWsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:48:40 -0500
Date: Fri, 25 Jan 2008 14:47:11 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Message-ID: <20080125224711.GA6323@suse.de>
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com> <20080125221548.GA15172@suse.de> <20080125223556.GB24708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125223556.GB24708@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:35:56PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > On Fri, Jan 25, 2008 at 01:05:40PM -0800, Yinghai Lu wrote:
> > > current linus tree + x86.git
> > > 
> > > got
> > > 
> > > Calling initcall 0xffffffff80b93d98: threshold_init_device+0x0/0x3f()
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > > IP: [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9
> > 
> > Does this happen on just Linus's tree?
> > 
> > Can you send me a .config file for this?
> > 
> > What is threshold_init()?  Is it something new in the x86.git tree?
> 
> no. A quick grep shows that it is in a file that _your_ changes in 
> Linus' latest have touched:
> 
>   arch/x86/kernel/cpu/mcheck/mce_amd_64.c

Ok, those are pretty much just search/and/replace type changes, but I
have been running x86-64 boxes with these changes in place.

That's why I'm interested if Linus's tree right now shows this problem,
and if I can get a .config of the offending kernel to try to reproduce
it and fix it myself.

thanks,

greg k-h
