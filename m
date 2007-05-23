Return-Path: <linux-kernel-owner+w=401wt.eu-S1764935AbXEWSFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764935AbXEWSFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXEWSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:05:00 -0400
Received: from smtp.osdl.org ([207.189.120.12]:42578 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbXEWSE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:04:59 -0400
Date: Wed, 23 May 2007 11:04:48 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Houston <mikeserv@bmts.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-ID: <20070523110448.3974948d@freepuppy>
In-Reply-To: <alpine.LFD.0.98.0705231044160.3890@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
	<20070521213146.3e220a44@freepuppy>
	<20070522181444.ad932718.mikeserv@bmts.com>
	<alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
	<20070523133909.a3ec171a.mikeserv@bmts.com>
	<alpine.LFD.0.98.0705231044160.3890@woody.linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 10:46:05 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 23 May 2007, Mike Houston wrote:
> > 
> > I still happen to have a Windows Vista install kicking around, so to
> > make sure we're not flogging a dead horse I booted that and let it
> > set up the yukon2 chip and I tested it. (more to make sure that
> > eeprom update didn't break it). I used it for a bit and successfully
> > transferred some large files from box running Samba. MS must be using
> > some specific workaround or something.
> 
> I think there is some lspci-like thing for windows too. 
> 
> Can you do the equivalent of "lspci -vvxxx" on that box under both Linux 
> and Windows? _If_ it's some PCI config space thing (which is not at all 
> guaranteed - it could be about setup in random MMIO ranges) it might give 
> us some clues.
> 
> 		Linus

lspci will work in windows, it is probably part of cygwin.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
