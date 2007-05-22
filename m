Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXEVEnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXEVEnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXEVEnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:43:13 -0400
Received: from smtp.osdl.org ([207.189.120.12]:35557 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbXEVEnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:43:12 -0400
Date: Mon, 21 May 2007 21:42:55 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mike Houston <mikeserv@bmts.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-ID: <20070521214255.3dc36445@freepuppy>
In-Reply-To: <4652733F.4030708@garzik.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
	<20070521213146.3e220a44@freepuppy>
	<4652733F.4030708@garzik.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 00:36:15 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Stephen Hemminger wrote:
> > There maybe some hardware level interaction with SATA controller.
> > I saw no failures running off i386 kernel of PATA drive and quickly
> > see errors with SATA/AHCI and x86_64.
> 
> 
> I presume AHCI is the only other device in the system using PCI MSI, 
> when you see problems?
> 
> 	Jeff
> 
> 
AHCI on this motherboard doesn't seem to use MSI. The problems occur
even if I boot with nomsi.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
