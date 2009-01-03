Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbZACULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbZACULq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbZACUK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:10:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50305 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759705AbZACUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:10:55 -0500
Date: Sat, 3 Jan 2009 13:29:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: defconfigs (x86 defconfig: increase CONFIG_LOG_BUF_SHIFT)
Message-ID: <20090103122949.GA1531@ucw.cz>
References: <200812282126.mBSLQ48J004583@hera.kernel.org> <49582A61.6040209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49582A61.6040209@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-12-28 17:39:45, Randy Dunlap wrote:
> Linux Kernel Mailing List wrote:
> > Author:     Ingo Molnar <mingo@elte.hu>
> > 
> >     x86 defconfig: increase CONFIG_LOG_BUF_SHIFT
> >     
> >     Impact: double the defconfig printk buffer
> >     
> >     Booting defconfigs produces more output than 128K so the output is
> >     truncated - double it to 256K.
> >     
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/configs/i386_defconfig   |    2 +-
> >  arch/x86/configs/x86_64_defconfig |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> Would someone attempt to explain the current purpose of defconfig files,
> please?

For machines like spitz (handheld with 64MB ram, arm, and mostly fixed
configuration) defconfig is very useful. Its basically impossible to
get all the stuff right so that it boots and finds root, otherwise...

For generic PC... well something like distro's config is still nice
starting point, but... 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
