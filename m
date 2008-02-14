Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbYBNOr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbYBNOr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYBNOrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:47:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbYBNOro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:47:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: first tree
Date: Thu, 14 Feb 2008 15:45:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141545.56488.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 of February 2008, Stephen Rothwell wrote:
> Hi all,
> 
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

Perhaps you can add:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6 test

Thanks,
Rafael
