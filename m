Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXCFW4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXCFW4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030554AbXCFW4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:56:14 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:36795 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030428AbXCFW4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:56:11 -0500
Date: Tue, 6 Mar 2007 22:47:25 +0100
From: Mattia Dongili <malattia@linux.it>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21 - part II (resend)
Message-ID: <20070306214725.GA3916@inferi.kami.home>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200702162223.59837.lenb@kernel.org> <20020101045751.GD4106@ucw.cz> <20070306122213.GF2919@inferi.kami.home> <20070306210959.GB3843@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306210959.GB3843@elf.ucw.cz>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc2-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 10:09:59PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > commit 4465857d5f99079bae00621626adf74ed8256296
> > > > Author: Mattia Dongili <malattia@linux.it>
> > > > Date:   Sat Jan 13 23:04:39 2007 +0100
> > > > 
> > > >     sony_acpi: Add lanpower and audiopower controls
> > > >     
> > > >     audiopower works well on my SZ72B so it's not marked has "debug" while lanpower
> > > >     has at least one report of not resuming power happily so morked as "debug"
> > > >     
> > > >     Signed-off-by: Mattia Dongili <malattia@linux.it>
> > > >     Signed-off-by: Len Brown <len.brown@intel.com>
> > > 
> > > What is interface to these? It would be nice to automagically disable
> > > audiopower when sound device is closed, and automagically power down
> > > lan on ifconfig ... down.
> > 
> > the audiopower is basically a _PS3/_PS0 switch for the device, while the
> > lanpower plays with the embedded controller to powerdown/powerup.
> > 
> > Now, unfortunately those methods are attached to a fake device in the
> > DSDT and afaict there's no way to tell which real device they are
> > playing with (except by inspecting the method implementations).
> 
> > Well of course iff there's only _one_ sound card and _one_ nic you can
> > easily guess it :)
> 
> Hmm... you are on sony notebook... right? That means it is very likely
> it has just one sound card, and just one ethernet, no?

I was thinking about hotpluggable audio/nic (pcmcia, usb). Anyway I have
a sky2 and ipw3945 and yes, just one sound card :)

-- 
mattia
:wq!
