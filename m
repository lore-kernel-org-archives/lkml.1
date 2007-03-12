Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbXCLUWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbXCLUWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXCLUWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:22:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3313 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752860AbXCLUWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:22:17 -0400
Date: Mon, 12 Mar 2007 10:43:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       alon.barlev@gmail.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64, i386: Add command line length to boot protocol
Message-ID: <20070312104352.GA4313@ucw.cz>
References: <20070306181430.GB3151@strauss.suse.de> <20070306182134.GB9491@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306182134.GB9491@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-03-06 13:21:34, Dave Jones wrote:
> On Tue, Mar 06, 2007 at 07:14:30PM +0100, Bernhard Walle wrote:
> 
>  > +cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
> 
> Why a long? It's unlikely that someone is going to have a command line
> bigger than 0xffff.

Well, I could imagine overflowing that. Describing your numa setup,
excluding few bad bits of ram using memmap=exact, set up your boot
over iscsi on cmdline.... these are likely to eat insane ammount of
cmdline space.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
