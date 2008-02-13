Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYBMHjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYBMHjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYBMHjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:39:00 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:45262 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYBMHi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:38:59 -0500
Date: Wed, 13 Feb 2008 08:38:56 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Miller <davem@davemloft.net>, greg@kroah.com,
       torvalds@linux-foundation.org, jeff@garzik.org, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212164726.8eecab43.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802130838200.8857@anakin>
References: <20080212174824.GA1919@kroah.com>
 <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org>
 <20080212191552.GA20883@kroah.com> <20080212.164149.209357519.davem@davemloft.net>
 <20080212164726.8eecab43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Andrew Morton wrote:
> On Tue, 12 Feb 2008 16:41:49 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> >  Here are some odd-the-cuff
> > suggestions:
> > 
> > 1) Make feature-removal-schedule a directory with files in it.
> >    Everyone touches that file, creating merge issues.
> > 
> > 2) Let's move away from some/dir/{Kconfig,Makefile} schemes and
> >    instead have each "thing" have it's own Kconfig.foo or
> >    Makefile.foo that gets automatically sucked into the main
> >    directory Makefile or Kconfig using file globs or similar.
> > 
> >    Even better, encode the building of things into the *.[ch]
> >    files themselves, and have the Kconfig/Makefile machinery
> >    automatically extract this information when you build.
> 
> 3) teach people that you don't always have to add new includes right
>    at the end of the list
> 
> 4) teach people that you don't have to add Makefile rules right at the
>    end of the list

If the list is already sorted, I insert it at the right position.
If not, well...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
