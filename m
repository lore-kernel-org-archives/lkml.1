Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbYABU6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbYABU6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYABU6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:58:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56947 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753528AbYABU6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:58:39 -0500
Date: Wed, 2 Jan 2008 15:58:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Mike Frysinger <vapier.adi@gmail.com>, <gregkh@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>,
       Robin Getz <rgetz@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options
 normally reserved for OTG
In-Reply-To: <200801021225.28370.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0801021556070.2990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, David Brownell wrote:

> On Wednesday 02 January 2008, Alan Stern wrote:
> > On Wed, 2 Jan 2008, Mike Frysinger wrote:
> > 
> > > perhaps the code size is arguable as to whether it really matters.
> > > the reason we want it is that we have a USB host controller that will
> > > not work with USB hubs, so we want to make sure the system does not
> > > attempt such things.  (yes, such a USB host controller is retarded,
> > > but the decision was out of our hands.)
> > 
> > Just out of curiosity, how does a host controller manage to avoid
> > working with external hubs? 
> 
> The transaction translators in external high speed hubs require
> hosts to issue particular USB transactions.  If the host controller
> doesn't implement the that split transaction support, then it won't
> be supporting external hubs.

So in theory one could connect a high-speed hub to such a host
controller and expect it to communicate with high-speed devices.  So
long as no full- or low-speed devices are added there wouldn't be any
split transactions.  It wouldn't be USB-2.0 compliant but it should
still work.

Alan Stern

