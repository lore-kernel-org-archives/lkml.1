Return-Path: <linux-kernel-owner+w=401wt.eu-S965992AbXDBWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965992AbXDBWMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965993AbXDBWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:12:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965992AbXDBWMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:12:19 -0400
Message-ID: <46117F72.6020506@zytor.com>
Date: Mon, 02 Apr 2007 15:10:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704022312.39195.ak@suse.de> <4611768D.1080801@garzik.org> <200704022336.43136.ak@suse.de> <461178D9.402@goop.org>
In-Reply-To: <461178D9.402@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>> The implementation wouldn't need to use PCI at all. There wouldn't 
>> even need to be PCI like registers internally. Just a pci device
>> with an ID somewhere in sysfs. PCI with unique IDs
>> is just a convenient and well established key into the driver module
>> collection. Once you have the right driver it can do what it wants.
> 
> But I understood hpa's suggestion to mean that there would be a standard
> PCI interface for a hardware RNG, and a single linux driver for that
> device, which all hypervisors would be expected to implement.  But
> that's only reasonable if the virtualization environment has some notion
> of PCI to expose to the Linux guest.
> 

That is, of course, true, although "some notion of" is very broad, and 
one could also use this for detection and some hypervisor-specific 
communication for the actual I/O.

However, one probably wants to think about what the heck one actually 
means with "virtualization" in the absence of a lot of this stuff.  PCI 
is probably the closest thing we have to a lowest common denominator for 
device detection.

	-hpa
