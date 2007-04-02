Return-Path: <linux-kernel-owner+w=401wt.eu-S965980AbXDBVxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965980AbXDBVxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965978AbXDBVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:53:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44519 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965980AbXDBVxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:53:45 -0400
Message-ID: <46117B62.9030902@us.ibm.com>
Date: Mon, 02 Apr 2007 16:53:38 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeff Garzik <jeff@garzik.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com, virtualization@lists.linux-foundation.org
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704022312.39195.ak@suse.de>	<4611768D.1080801@garzik.org> <200704022336.43136.ak@suse.de> <461178D9.402@goop.org>
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

The actual PCI bus could paravirtualized.  It's just a question of 
whether one reinvents a device discovery mechanism (like XenBus) or 
whether one piggy backs on existing mechanisms.

Furthermore, in the future, I strongly suspect that HVM will become much 
more important for Xen than PV and since that already has a PCI bus it's 
not really that big of a deal.

Regards,

Anthony Liguori

>     J

