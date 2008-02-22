Return-Path: <linux-kernel-owner+w=401wt.eu-S936568AbYBVCGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936568AbYBVCGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935878AbYBVCGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:06:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40013 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423AbYBVCGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:06:38 -0500
Date: Fri, 22 Feb 2008 02:06:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222020615.GE27894@ZenIV.linux.org.uk>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE2985.6020305@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE2985.6020305@davidnewall.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 12:16:45PM +1030, David Newall wrote:
> Krzysztof Halasa wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> >> I'm personally of the opinion that a lot of checkpatch "fixes" are 
> >> anything but. That mainly concerns fixing overlong lines
> >>     
> >
> > Perhaps we should increase line length limit, 132 should be fine.
> > Especially useful with long printk() lines and long arithmetic
> > expressions.
> >   
> 
> 
> Yes; or even longer.  80 characters might have made sense on a screen
> when the alternative was 80 characters on a punched card, but on a
> modern computer it's very restrictive.  That's especially true with the
> deep indents that you quickly get in C

... if your style is lousy.  I agree that situation with printks is
not normal in that respect and I certainly have no love for the
checkpatch nonsense, but pressure to keep the fucking nesting depth
low is a Good Thing(tm).
