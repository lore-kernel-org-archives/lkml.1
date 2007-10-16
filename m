Return-Path: <linux-kernel-owner+w=401wt.eu-S966316AbXJPWd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966316AbXJPWd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965392AbXJPWds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:33:48 -0400
Received: from thunk.org ([69.25.196.29]:50519 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbXJPWdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:33:47 -0400
Date: Tue, 16 Oct 2007 18:33:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Mark Lord <lkml@rtr.ca>, pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
Message-ID: <20071016223342.GE1314@closure.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Mark Lord <lkml@rtr.ca>, pcihpd-discuss@lists.sourceforge.net,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016140116.cb30483c.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016140116.cb30483c.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 02:01:16PM -0700, Kristen Carlson Accardi wrote:
> > 
> > I believe the code is leaning too heavily on the BIOS for stuff,
> > and like lots of other parts of the kernel we'll need an alternate
> > strategy for when things aren't "perfect".
> 
> the pitfall for forcing pciehp when the BIOS hasn't provided OSC is that
> you don't know for sure that you really have gained control of hot plug
> operation properly.  You can obviously try it, using the provide forcing
> option as you have done, but the behavior is not predictable.

The bigger concern is whether this likely to break things on systems
that *do* correctly implement ACPI support for PCIe hotplug?

     	  	    	      	   	       - Ted


