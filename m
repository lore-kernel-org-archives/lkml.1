Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbXGYFRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbXGYFRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXGYFRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:17:42 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:32376 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbXGYFRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:17:42 -0400
Date: Wed, 25 Jul 2007 08:16:51 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, ak@suse.de, jdmason@us.ibm.com
Subject: Re: [PATCH] x86_64 tce section mismatch
Message-ID: <20070725051651.GA5575@rhun.haifa.ibm.com>
References: <20070724141702.a9f63ae4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724141702.a9f63ae4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:17:02PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch warnings:
> these functions are called only from __init functions.
> 
> WARNING: vmlinux.o(.text+0x1861c): Section mismatch: reference to .init.text:free_bootmem (between 'free_tce_table' and 'build_tce_table')
> WARNING: vmlinux.o(.text+0x187e5): Section mismatch: reference to .init.text:__alloc_bootmem_low (between 'alloc_tce_table' and 'kretprobe_trampoline_holder')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

At some point in time we will need to support hotplug with IOMMU
translation enabled, in which case they'll be called when hotplug
happens as well, but in the mean time

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>

I'll push it with the next Calgary update unless Andi picks it up
first.

Cheers,
Muli
