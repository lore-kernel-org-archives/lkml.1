Return-Path: <linux-kernel-owner+w=401wt.eu-S934902AbYEVBXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902AbYEVBXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760332AbYEVBXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:23:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51004
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbYEVBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:23:40 -0400
Date: Wed, 21 May 2008 18:23:35 -0700 (PDT)
Message-Id: <20080521.182335.28689253.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: viro@ZenIV.linux.org.uk, paulus@samba.org, tiwai@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-*
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>
	<20080522005657.GU28946@ZenIV.linux.org.uk>
	<alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 May 2008 18:20:27 -0700 (PDT)

> On Thu, 22 May 2008, Al Viro wrote:
> > 
> > Eh?  git mv include/asm-$i arch/$i/include/asm, then?
> 
> Yeah, sorry, I dropped an "include/" there. 
> 
> > Nice, but... how do you pull what's currently asm-generic/foo.h from what's
> > currently asm-bar/foo.h?  #include_next is _ugly_...
> 
> I was actually going to suggest #include_next, yes. But if people hate it, 
> we can certainly just keep the current <asm-generic/xyz.h> approach.

This discussion reminds me of one of my (numerous) pet peeves
about the glibc source tree.

If you want to figure out where something is implemented for a given
target, you have to walk through the tree like a monkey in some
prioritized list of directories to find the source file or header file
that glibc ends up using.

At least with what we're using now, you open up the file for ARCH and
you see the includes so you know exactly where to go.

So I think this "just provide no file to use default implementation"
might not be the best idea in the long term.
