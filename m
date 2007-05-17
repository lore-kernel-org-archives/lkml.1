Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXEQKkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXEQKkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbXEQKkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:40:12 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:53396 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbXEQKkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:40:11 -0400
Date: Thu, 17 May 2007 11:40:08 +0100
To: Bob Picco <bob.picco@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, apw@shadowen.org
Subject: Re: PPC64 build breakage drivers/pci/hotplug/rpadlpar_sysfs.c
Message-ID: <20070517104008.GA667@skynet.ie>
References: <20070516133046.GB25792@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070516133046.GB25792@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/05/07 09:30), Bob Picco didst pronounce:
> bob.picco@hp.com
> Bcc: 
> Subject: Re: 2.6.22-rc1-mm1 powerpc build breakage
> Reply-To: 
> In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
> 
> /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `subsys' specified in initializer
> /usr/src/linux-2.6.22-rc1-mm1/drivers/pci/hotplug/rpadlpar_sysfs.c:132: warning: initialization from incompatible pointer type
> make[4]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> make[3]: *** [drivers/pci/hotplug] Error 2
> make[2]: *** [drivers/pci] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [_all] Error 2
> 

This is showing up on TKO as well and Andy Whitcroft has kicked it
around a bit as far as I know. He makes it build with this patch
http://test.kernel.org/abat/88951/build/patches/update-sysfs-kset-initialisation-in-PPC64-DLPAR-IO-driver

However, my understand is that the driver is broken even though it builds
but I don't recall why. I've added Andy to the CC

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
