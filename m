Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbYHDWVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbYHDWVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYHDWVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:21:37 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40257 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYHDWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:21:36 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Mon, 4 Aug 2008 16:20:35 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <1217786532.4179.24.camel@localhost.localdomain> <200808041443.20942.bjorn.helgaas@hp.com> <20080804213535.GM26461@parisc-linux.org>
In-Reply-To: <20080804213535.GM26461@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041620.35487.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 03:35:35 pm Matthew Wilcox wrote:
> On Mon, Aug 04, 2008 at 02:43:20PM -0600, Bjorn Helgaas wrote:
> > I tried to standardize the PCI core on "[%04x/%04x]" for vendor/device ID.
> 
> That's unfortunately different from lspci -nn:
> 
> 00:00.0 Host bridge [0600]: Intel Corporation Mobile PM965/GM965/GL960
> Memory Controller Hub [8086:2a00] (rev 03)
> 
> Sorry, I should have reviewed your patches ;-(

I can change those.  I just copied what seemed to be the most
prevalent.  But lspci is harder to change, so we should probably
follow that.
