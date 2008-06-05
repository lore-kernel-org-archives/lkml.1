Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYFEPMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYFEPMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYFEPMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:12:23 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:22866 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYFEPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:12:23 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc5
Date: Thu, 5 Jun 2008 09:12:14 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alejandro Riveira =?iso-8859-15?q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <20080605150306.18c00bd9@Varda> <alpine.LFD.1.10.0806050749570.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806050749570.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806050912.15579.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 08:54:24 am Linus Torvalds wrote:
> 
> On Thu, 5 Jun 2008, Alejandro Riveira Fernández wrote:
> >
> >  I got this on my dmesg; is this expected/harmaless?
> >  (btw The wireless driver oops that i reported is gone as it is the 
> >  bluetooth one ;)
> > 
> ..
> > [    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
> > [    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
> .. repeated a lot ..
> 
> It's harmless but obviously irritating. The PnP resource manager changes 
> need a few cleanups still - it's getting confused about IORESOURCE_UNSET 
> vs IORESOURCE_DISABLED.

Yep, Tony Luck reported this yesterday as well.  I'll work up a
patch this morning.

Bjorn
