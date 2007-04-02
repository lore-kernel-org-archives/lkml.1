Return-Path: <linux-kernel-owner+w=401wt.eu-S965955AbXDBVgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965955AbXDBVgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965957AbXDBVgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:36:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965955AbXDBVgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:36:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: A set of "standard" virtual devices?
Date: Mon, 2 Apr 2007 23:36:42 +0200
User-Agent: KMail/1.9.6
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704022312.39195.ak@suse.de> <4611768D.1080801@garzik.org>
In-Reply-To: <4611768D.1080801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704022336.43136.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 23:33:01 Jeff Garzik wrote:
> Andi Kleen wrote:
> >> How would that work in the case where virtualized guests don't have a
> >> visible PCI bus, and the virtual environment doesn't pretend to emulate
> >> a PCI bus?
> > 
> > If they emulated one with the appropiate device 
> > then distribution driver auto probing would just work transparently for them.
> 
> Yes, but, ideally with paravirtualization you should be able to avoid 
> the overhead of emulating many major classes of device (storage, 
> network, RNG, etc.) by developing a low-overhead passthrough interface 
> that does not involve PCI at all.

The implementation wouldn't need to use PCI at all. There wouldn't 
even need to be PCI like registers internally. Just a pci device
with an ID somewhere in sysfs. PCI with unique IDs
is just a convenient and well established key into the driver module
collection. Once you have the right driver it can do what it wants.

-Andi 
