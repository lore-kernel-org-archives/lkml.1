Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYLUCX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYLUCX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 21:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYLUCXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 21:23:50 -0500
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:42463 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYLUCXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 21:23:49 -0500
Date: Sat, 20 Dec 2008 18:23:23 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: "Darrick J. Wong" <djwong@us.ibm.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>, Alex Chiang <achiang@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding	the?device
In-Reply-To: <20081216205650.GH25300@plum>
Message-ID: <Pine.LNX.4.58.0812201812100.19510@shell2.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.58.0811281303230.30153@shell4.speakeasy.net>
 <200812011808.31906.eike-kernel@sf-tec.de> <200812161133.33894.jbarnes@virtuousgeek.org>
 <20081216205650.GH25300@plum>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008, Darrick J. Wong wrote:
> On Tue, Dec 16, 2008 at 11:33:33AM -0800, Jesse Barnes wrote:
> > > I read it, but that's the way a kernel works: if you want to talk to a
> > > device, get a driver. You can write a rather minimal one that does only
> > > pci_enable_device() on probe and pci_disable_device() on remove. Try the
> > > one posted by Chris Wright in "[PATCH 2/2] PCI: pci-stub module to reserve
> > > pci device" as a starting point.
> >
> > Ok, so sounds like Darrick's original patch gets a NAK?  I guess the fakephp
> > vs. dummyphp vs. new interface stuff can be dealt with in another thread...
>
While fakephp may be a mess, Darrick's patch does fix a problem with it.

> In any case, I gave 2.6.24 a whirl.  2.6.24 fakephp sets up the BARs
> correctly, so technically this is a regression fix too, even if only a
> stopgap.

I know 2.6.23 has the same problem with resources not being assigned
correctly to BARs as 2.6.27.  It doesn't look like there are any patches in
2.6.24 that would have fixed it.
