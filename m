Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbXFSTEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbXFSTEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764131AbXFSTEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:04:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58676 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932201AbXFSTEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:04:37 -0400
Date: Tue, 19 Jun 2007 15:04:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Walmsley <paul@booyaka.com>
cc: Oliver Neukum <oliver@neukum.org>,
       "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       <linux-usb-devel@lists.sourceforge.net>,
       Chuck Ebbert <cebbert@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] Error -71 on device descriptor read/all
In-Reply-To: <Pine.LNX.4.64.0706191134160.12843@utopia.booyaka.com>
Message-ID: <Pine.LNX.4.44L0.0706191502090.2552-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Paul Walmsley wrote:

> On Tue, 19 Jun 2007, Oliver Neukum wrote:
> 
> > Am Dienstag, 19. Juni 2007 schrieb Chuck Ebbert:
> >
> >> Try disabling CONFIG_USB_SUSPEND
> >>
> >> [usb developers: what are the drawbacks of doing this?]
> >
> > Increased power consumption.
> 
> speaking of CONFIG_USB_SUSPEND, I've encountered at least one device -- a 
> Canon EOS 5D camera -- that, after the bus suspends, must be powercycled 
> in order to return the camera's interrupt endpoints to a functional state. 
> How are these types of problems handled, currently?  Is this something for 
> a blacklist?

There are a few possible approaches.  One is indeed a blacklist, to 
prevent the camera from automatically being suspended.  Another is to 
prevent it by changing a device parameter in sysfs.

Note that neither of these will help if you do a suspend-to-RAM.  That 
suspends everything.

Alan Stern

