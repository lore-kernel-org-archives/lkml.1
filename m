Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbXEQNhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbXEQNhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbXEQNhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:37:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51864 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbXEQNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:37:44 -0400
Message-ID: <464C5AA5.3090002@linux.vnet.ibm.com>
Date: Thu, 17 May 2007 08:37:41 -0500
From: Brian King <brking@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Bob Picco <bob.picco@hp.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PPC64 build breakage drivers/pci/hotplug/rpadlpar_sysfs.c
References: <20070516133046.GB25792@localhost> <20070517104008.GA667@skynet.ie>
In-Reply-To: <20070517104008.GA667@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (16/05/07 09:30), Bob Picco didst pronounce:
>> bob.picco@hp.com
>> /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `subsys' specified in initializer
>> /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: warning: initialization from incompatible pointer type
>> make[4]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
>> make[3]: *** [drivers/pci/hotplug] Error 2
>> make[2]: *** [drivers/pci] Error 2
>> make[1]: *** [drivers] Error 2
>> make: *** [_all] Error 2
>>
> 
> This is showing up on TKO as well and Andy Whitcroft has kicked it
> around a bit as far as I know. He makes it build with this patch
> http://test.kernel.org/abat/88951/build/patches/update-sysfs-kset-initialisation-in-PPC64-DLPAR-IO-driver
> 
> However, my understand is that the driver is broken even though it builds
> but I don't recall why. I've added Andy to the CC

Al Viro posted a patch yesterday that fixes this:

http://ozlabs.org/pipermail/linuxppc-dev/2007-May/036222.html

It's in mainline now.

-Brian
