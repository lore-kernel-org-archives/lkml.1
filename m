Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYBQTKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYBQTKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbYBQTKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:10:07 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:5593 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbYBQTKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:10:05 -0500
Date: Sun, 17 Feb 2008 14:09:57 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-ID: <20080217190957.GA29415@jupiter.solarsys.private>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen:

* Stephen Rothwell <sfr@canb.auug.org.au> [2008-02-15 00:35:37 +1100]:
> I have created the first cut of the linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> Things to know about this tree:
> 
> It has two branches - master and stable.  Stable is currently just Linus'
> tree and will never rebase.  Master will rebase on an almost daily basis
> (maybe slower at the start).
> 
> The tree consists of subsystem git and quilt trees.  Currently, the quilt
> trees are integrated by importing them into appropriately based git
> branches and then merging those branches.  This has the advantage that
> any conflict resolution will onlt have to happen once at the merge point
> rather than, possibly, sevveral times during the series.  However, I am
> considering just applying the quilt trees on top of the current tree
> to get a result more like Linus' tree - we will see. The git trees are
> obviously just merged.
> 
> Between each merge, the tree was built with both an allmodconfig for both
> powerpc and x86_64.
> 
> The tree currently contains:
> 	Greg's driver-core, pci and usb quilt series (in that order)
> 	Alasdair Kergon's device-mapper quilt tree
> 	Jiri Kosina's hid git tree
> 	Jean Delvare's i2c quilt tree
> 	Randy Dunlap's kernel-doc quilt tree
> 	Haavard Skinnemoen's avr32 git tree
> 
> There was only one unresolved conflict which could have been caused
> because I was not sure where to base the kernel-doc tree.
> 
> So, comments, please.
> 
> Also, more trees please ... :-)

You can add the hwmon testing tree (from MAINTAINERS): 

> git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git testing

This tree gets rebased pretty much whenever Linus adds a new tag.  As a
rule of thumb, you should merge from Jean Delvare's i2c tree first.  The
hwmon/testing tree does not usually depend on anything else.

Thanks & regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

