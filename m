Return-Path: <linux-kernel-owner+w=401wt.eu-S965963AbXDBVmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965963AbXDBVmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965962AbXDBVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:42:54 -0400
Received: from gw.goop.org ([64.81.55.164]:34263 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965963AbXDBVmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:42:52 -0400
Message-ID: <461178D9.402@goop.org>
Date: Mon, 02 Apr 2007 14:42:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Jeff Garzik <jeff@garzik.org>, virtualization@lists.linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704022312.39195.ak@suse.de> <4611768D.1080801@garzik.org> <200704022336.43136.ak@suse.de>
In-Reply-To: <200704022336.43136.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The implementation wouldn't need to use PCI at all. There wouldn't 
> even need to be PCI like registers internally. Just a pci device
> with an ID somewhere in sysfs. PCI with unique IDs
> is just a convenient and well established key into the driver module
> collection. Once you have the right driver it can do what it wants.

But I understood hpa's suggestion to mean that there would be a standard
PCI interface for a hardware RNG, and a single linux driver for that
device, which all hypervisors would be expected to implement.  But
that's only reasonable if the virtualization environment has some notion
of PCI to expose to the Linux guest.

    J
