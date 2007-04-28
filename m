Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXD1BBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXD1BBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030591AbXD1BBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:01:40 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:38026 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030572AbXD1BBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:01:39 -0400
Date: Sat, 28 Apr 2007 02:00:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Message-ID: <20070428010043.GA21136@srcf.ucam.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <463292C8.9000307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463292C8.9000307@goop.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Back to the future.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 05:18:16PM -0700, Jeremy Fitzhardinge wrote:

> Then you could use kexec for resume...

While that would certainly be nifty, I think we're arguably starting 
from the wrong point here. Why are we booting a kernel, trying to poke 
the hardware back into some sort of mock-quiescent state, freeing memory 
and then (finally) overwriting the entire contents of RAM rather than 
just doing all of this from the bootloader? Given the time spent in 
kernel setup and unpacking initramfs nowadays, I'm willing to bet it'd 
still be faster even if you're stuck using int 13 on x86.

http://apcmag.com/5873/page14 suggests that Intel is looking into this, 
but I haven't heard anything more yet. To the best of my knowledge, this 
is also how Windows manages things.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
