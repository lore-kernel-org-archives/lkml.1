Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZGGDSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZGGDSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 23:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZGGDSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 23:18:24 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:11077 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZGGDSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 23:18:23 -0400
Date: Mon, 06 Jul 2009 23:17:29 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: acpi tree build failure
In-reply-to: <20090630131645.68c81f0b.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.0907062315570.32467@localhost.localdomain>
References: <20090630131645.68c81f0b.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Stephen Rothwell wrote:

> Hi Len,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
>   GEN     /scratch/sfr/powerpc_ppc64_defconfig/Makefile
> drivers/platform/x86/Kconfig:353:error: found recursive dependency: EEEPC_LAPTOP -> HOTPLUG_PCI -> EEEPC_LAPTOP
> 
> Caused by commit 6af05c22969dce2776375953131b56e9f4282848 ("eeepc-laptop:
> Register as a pci-hotplug device") interacting with commit
> 44b3615b8cb3b016a49eb7ef4236e77a77793cec ("eeepc-laptop: Fix build
> failure with HOTPLUG_PCI && !SYSFS") from Linus' tree.  Commit 6af05c2
> from the acpi tree is the same as commit
> 2b121bc262fa03c94e653b2d44356c2f86c1bcdc in Linus' tree that 44b3615b is
> fixing, so I have reverted the drivers/platform/x86/Kconfig part of
> 6af05c2 for today.

Sorry I broke your build, Stephen.

This was an obsolete patch in the acpi-test tree.
it should be better now.   Thanks for working around it.

Len Brown, Intel Open Source Technology Center

