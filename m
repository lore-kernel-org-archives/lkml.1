Return-Path: <linux-kernel-owner+w=401wt.eu-S965997AbXDBWaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965997AbXDBWaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966001AbXDBWaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:30:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52026 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965997AbXDBWay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:30:54 -0400
Message-ID: <46118410.2060904@zytor.com>
Date: Mon, 02 Apr 2007 15:30:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704022312.39195.ak@suse.de> <4611768D.1080801@garzik.org> <200704022336.43136.ak@suse.de> <461178D9.402@goop.org> <46117F72.6020506@zytor.com> <461182BE.5040902@garzik.org>
In-Reply-To: <461182BE.5040902@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Sure, but let's look beyond device detection.  For instance, it does not 
> necessarily follow that emulating PCI DMA is the best way to go for 
> communication with a virtual device, once detected.
> 

This is true, of course.  However, there are going to be a set of 
virtual devices which don't necessarily have to have super-high 
performance.  In the case of a hwrng device, even doing DMA is probably 
overkill.

> Outside of pci_device_id driver matching, is there much value here?

If we can get a set of device drivers that if not all then at least a 
number of hypervisors and/or emulators can agree upon, I think that's 
much won.

	-hpa
