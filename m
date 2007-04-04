Return-Path: <linux-kernel-owner+w=401wt.eu-S933618AbXDDPvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbXDDPvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934048AbXDDPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:51:04 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618AbXDDPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:51:01 -0400
Message-ID: <4613C941.6040706@zytor.com>
Date: Wed, 04 Apr 2007 08:50:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com, virtualization@lists.linux-foundation.org
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704040049.13118.arnd@arndb.de> <4612F6E9.7040003@zytor.com> <200704041511.42543.arnd@arndb.de>
In-Reply-To: <200704041511.42543.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
>> That being said, on platforms which are PCI-centric, such as x86, this 
>> of course makes it a lot easier to produce virtual devices which work 
>> across hypervisors, since the device model, of *any* operating system is 
>> set up to handle them.
> 
> Yes, as I said there are two separate problems. I really think that
> a standardized virtual driver interface should be modeled after
> kernel <-> user interfaces, not hardware <-> kernel interfaces.
> 
> Once we know what operations we want (e.g. read, write and SIGIO,
> or some other set of primitives), it will be good to provide a
> virtual PCI device that can be used as one transport mechanism
> below it. Using PCI device IDs to tell what functionality is
> provided by the device would provide a reasonable method for
> autoprobing.
> 

That seems like a reasonable approach.  I *do* care about 
hardware-equivalent interfaces, because they, too, keep getting 
reinvented, but it seems reasonable to approach it in a layered fashion 
like you describe.

	-hpa

