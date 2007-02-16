Return-Path: <linux-kernel-owner+w=401wt.eu-S1946034AbXBPSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946034AbXBPSsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946038AbXBPSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:48:21 -0500
Received: from iabervon.org ([66.92.72.58]:2042 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946034AbXBPSsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:48:21 -0500
Date: Fri, 16 Feb 2007 13:48:15 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Heikki Orsila <shdl@zakalwe.fi>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] New driver information
In-Reply-To: <20070216135851.GA7939@zakalwe.fi>
Message-ID: <Pine.LNX.4.64.0702161334170.20138@iabervon.org>
References: <20070216135851.GA7939@zakalwe.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Heikki Orsila wrote:

> I just read
> 
> 	http://kerneltrap.org/node/7729
> 
> and it occured to me that it would be informative to have a new device 
> driver macro. The motivation for the new macro would be 4 issues:
> 
> 	* Is it possible to get specifications for the device?
> 	* If yes, under what terms? (nda, public)
> 	* Where to get public specs?
> 	* How many closed and open drivers in the Linux source tree?

This doesn't make any sense as a driver macro, because it's per device, 
not per driver. E.g., the sdhci driver drives a number of devices, 
including both well-documented devices and devices whose only 
documentation is that the PCI ID matches (and they work with only a few 
quirks).

On the other hand, a kconfig-readable table of PCI, USB, etc IDs with this 
information isn't a bad idea, especially if the drivers actually depend on 
it (so that it has to be kept up to date, at least as far as the 
device/driver mapping).
