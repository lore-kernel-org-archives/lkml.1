Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZFDWr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZFDWr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZFDWrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:47:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:46533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbZFDWrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:47:20 -0400
Date: Fri, 5 Jun 2009 00:47:18 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: drivers/serial/Kconfig: .ko is normally not included in kconfig
 help
In-Reply-To: <20090604143140.GF29005@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.0906050046350.7457@wotan.suse.de>
References: <20090514111556.GA9347@elf.ucw.cz> <alpine.LNX.2.00.0905141350320.22712@wotan.suse.de> <20090604143140.GF29005@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Pavel Machek wrote:

> > > commit 3f582fadb61bfcf948609b9fa5d832d2bab098a7
> > > tree c0adf6e1122a15be49c046d1c84f94c6a61ff73c
> > > parent 4d874471a704784cf7e0fe1bf7e9c050d0e1063c
> > > author Pavel <pavel@ucw.cz> Thu, 14 May 2009 13:15:20 +0200
> > > committer Pavel <pavel@ucw.cz> Thu, 14 May 2009 13:15:20 +0200
> > > 
> > >  drivers/serial/Kconfig |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> > > index 343e3a3..472a572 100644
> > > --- a/drivers/serial/Kconfig
> > > +++ b/drivers/serial/Kconfig
> > > @@ -860,7 +860,7 @@ config SERIAL_UARTLITE
> > >  	  Say Y here if you want to use the Xilinx uartlite serial controller.
> > >  
> > >  	  To compile this driver as a module, choose M here: the
> > > -	  module will be called uartlite.ko.
> > > +	  module will be called uartlite.
> > 
> > Why not fix all the in-tree instances while you are at it? (quick grep 
> > shouws that there is ~25 of them)
> Can you take this one and I'll fix more as separate patch?

Thanks for all the patches, I have folded them into a single bigger patch 
and applied to trivial queue.

-- 
Jiri Kosina
