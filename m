Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZFHDLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZFHDLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZFHDKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:10:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52998 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751419AbZFHDKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:10:50 -0400
Date: Sun, 7 Jun 2009 23:10:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: alan-jenkins@tuffmail.co.uk, Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       <acpi4asus-user@lists.sourceforge.net>, <len.brown@intel.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
In-Reply-To: <20090608030732.GA7018@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0906072309560.28801-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Matthew Garrett wrote:

> On Sun, Jun 07, 2009 at 11:03:48PM -0400, Alan Stern wrote:
> 
> > There's no mechanism for this.  It many environments it couldn't work,
> > because the decision about whether to enable autosuspend is made when
> > the device is first created (i.e., when the creation uevent is
> > received), whereas driver binding doesn't occur until later.
> 
> There's a lot of power management situations where you don't end up with 
> the optimal power configuration until a driver's bound. It's certainly 
> possible to do this in userspace, but if we know that the hardware 
> supported by a given driver will always work then it seems reasonable to 
> have it whitelist autosuspend on that device.

Sure.  Such a thing could be added easily enough.  It just doesn't 
exist now, that's all.

Alan Stern

