Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932Ab0AXQfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0AXQfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656Ab0AXQe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:34:59 -0500
Received: from www.tglx.de ([62.245.132.106]:58314 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0AXQe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:34:59 -0500
Date: Sun, 24 Jan 2010 17:29:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk, Xiaotian Feng <dfeng@redhat.com>
Subject: Re: [stable] [00/29] 2.6.32.6 stable review
In-Reply-To: <20100123232152.4b88d1e3.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain>
References: <20100123001145.GA7391@kroah.com> <20100123232152.4b88d1e3.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010, Andrew Morton wrote:

> On Fri, 22 Jan 2010 16:11:45 -0800 Greg KH <gregkh@suse.de> wrote:
> 
> > This is the start of the stable review cycle for the 2.6.32.6 release.
> > There are 29 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Responses should be made by Monday, January 24, 00:00:00 UTC.
> > Anything received after that time might be too late.
> 
> 2.6.32.6 will still contain the regression described in (for example)
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=15117 
> http://bugzilla.kernel.org/show_bug.cgi?id=15005
> 
> It's fixed with the below revert which has been in -mm (and only in
> -mm) for ten days.
> 
> I don't what's going on - perhaps we're waiting for Thomas, and he's
> otherwise engaged.  There's a fix in the lkml thread "Re: [RFC PATCH
> 0/4] clockevents: fix clockevent_devices list corruption after cpu
> hotplug" to which Thomas replied
> 
>     I just applied your patch, but kept the cpuweight check.  This
>     is the least intrusive solution for now.  The logic needs an
>     overhaul, but thats neither rc4 nor stable material"

Just sent the pull request for it. Sorry for the delay. The patch
needs to go into 32.6 as well.

Thanks,

	tglx
