Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZALKOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZALKOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZALKOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:14:36 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:59227 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZALKOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:14:35 -0500
Date: Mon, 12 Jan 2009 11:16:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       geert@linux-m68k.org, dhowells@redhat.com
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20090112101616.GA10086@uranus.ravnborg.org>
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org> <20081217091058.GB28946@ZenIV.linux.org.uk> <20081217112723.GA5027@uranus.ravnborg.org> <20081217170257.GE28946@ZenIV.linux.org.uk> <20081217171800.GA5436@uranus.ravnborg.org> <48E9B842.1020303@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E9B842.1020303@snapgear.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 05:03:30PM +1000, Greg Ungerer wrote:
> Hi Sam,
> 
> Sam Ravnborg wrote:
> >On Wed, Dec 17, 2008 at 05:02:57PM +0000, Al Viro wrote:
> >>	BTW, after taking a look at the remaing asm-*...
> >>
> >>* frv, m32r and h8300 should be as trivial as git mv
> >
> >Yep - I already have positive feedback from arch maintainers that
> >they will fix it in the -rc1 timeframe.
> >
> >>* m68k has a bit of extra PITA - we need to clean up two non-trivial
> >>  includes from m68knommu (pci.h and setup.h) first, then it's a matter
> >>  of git mv, adding arch/m68k/include to search path on m68knommu and
> >>  removal of dummy headers from the latter.
> >
> >I took a different route here and unified the headers for m68k and 
> >m68knommu
> >under arch/m68k/include/asm
> >It was based on a script originally developed by Arnd Bergmann.
> >
> >Geert already acked it, and I expect Greg to apply it in the -rc1 
> >timeframe.
> 
> I have been away for the last few weeks, so I haven't looked at this
> at all yet. I will over the next few days though.

Great!
Linus has taken those "move a lot of headers" patches after -rc1
before so I hope he will take this (and the other pending stuff from
other archs) this round too.

	Sam
