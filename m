Return-Path: <linux-kernel-owner+w=401wt.eu-S965996AbXDBWZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965996AbXDBWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965999AbXDBWZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:25:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58536 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965996AbXDBWZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:25:13 -0400
Message-ID: <461182BE.5040902@garzik.org>
Date: Mon, 02 Apr 2007 18:25:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704022312.39195.ak@suse.de> <4611768D.1080801@garzik.org> <200704022336.43136.ak@suse.de> <461178D9.402@goop.org> <46117F72.6020506@zytor.com>
In-Reply-To: <46117F72.6020506@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> However, one probably wants to think about what the heck one actually 
> means with "virtualization" in the absence of a lot of this stuff.  PCI 
> is probably the closest thing we have to a lowest common denominator for 
> device detection.


Sure, but let's look beyond device detection.  For instance, it does not 
necessarily follow that emulating PCI DMA is the best way to go for 
communication with a virtual device, once detected.

Outside of pci_device_id driver matching, is there much value here?

	Jeff


