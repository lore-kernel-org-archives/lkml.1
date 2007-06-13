Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbXFMR7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbXFMR7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbXFMR66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:58:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:52672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555AbXFMR66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:58:58 -0400
Date: Wed, 13 Jun 2007 19:58:50 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070613175850.GA8457@suse.de>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070611120034.f6d972de.akpm@linux-foundation.org> <pan.2007.06.11.19.49.44@free.fr> <20070612151256.GC5986@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070612151256.GC5986@ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha5, Kernel 2.6.22-rc4-git3-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 03:12:57PM +0000, Pavel Machek wrote:
> Hi!
> 
> (please group reply)
> 
> > > How does the beep get turned off again?
> > May be it is turn off by the speaker driver.
> > 
> > 
> > BTW can't we do something with led ? This way it can be always enabled 
> > without anoying people
> 
> It would be more complex code, afaict, and ps/2 keyboard may be
> absent. But feel free to try, I'm not even sure beeping works
> everywhere, so another hack would be nice...

Many machines / keyboards blink the LEDs on power up and on resume anyway,
so it is hard to see if the blink was from the BIOS or from Linux.
And don't we need to resume the keyboard controller before we can start
blinking the LEDs?
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
