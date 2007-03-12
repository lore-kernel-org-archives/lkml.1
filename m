Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbXCLU4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbXCLU4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXCLU4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:56:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbXCLU4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:56:01 -0400
Date: Mon, 12 Mar 2007 16:55:13 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, alon.barlev@gmail.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64, i386: Add command line length to boot protocol
Message-ID: <20070312205513.GC21835@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>, alon.barlev@gmail.com,
	ak@suse.de, linux-kernel@vger.kernel.org
References: <20070306181430.GB3151@strauss.suse.de> <20070306182134.GB9491@redhat.com> <20070312104352.GA4313@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312104352.GA4313@ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 10:43:52AM +0000, Pavel Machek wrote:
 > On Tue 2007-03-06 13:21:34, Dave Jones wrote:
 > > On Tue, Mar 06, 2007 at 07:14:30PM +0100, Bernhard Walle wrote:
 > > 
 > >  > +cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
 > > 
 > > Why a long? It's unlikely that someone is going to have a command line
 > > bigger than 0xffff.
 > 
 > Well, I could imagine overflowing that. Describing your numa setup,
 > excluding few bad bits of ram using memmap=exact, set up your boot
 > over iscsi on cmdline.... these are likely to eat insane ammount of
 > cmdline space.

65535 characters? Are you for real?
Stop and think about just how big that is. If you have to create
a boot command line that long, you have serious, serious issues.

	Dave

-- 
http://www.codemonkey.org.uk
