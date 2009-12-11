Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZLKUXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZLKUXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZLKUXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:23:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbZLKUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:23:06 -0500
Date: Fri, 11 Dec 2009 12:22:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Lin Ming <ming.m.lin@intel.com>,
       Len Brown <len.brown@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.33
In-Reply-To: <20091211110222.0ae1d897@jbarnes-piketon>
Message-ID: <alpine.LFD.2.00.0912111216431.3560@localhost.localdomain>
References: <20091211110222.0ae1d897@jbarnes-piketon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, Jesse Barnes wrote:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next
> 
> I've got a section mismatch in here, but the fix will be part of the next
> pull req (updated patch just came in recently).
> 
> Probably the biggest change here (at least my change count) is Bjorn's
> MMCONFIG rework.  It sets the stage for hot plugging of host bridges and
> _CBA and includes some nice cleanups besides.

Ok, so I got a few conflicts with the iommu/dmar changes (ACS related 
changes versus the iommu_init changes) and with the ACPICA update 
(acpi_walk_namespace() change in acpiphp_glue - it now takes a post-order 
callback too).

I resolved them all, hopefully even correctly, but people should look over 
the end result.

		Linus
