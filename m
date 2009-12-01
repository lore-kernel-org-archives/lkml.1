Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZLAUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZLAUkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZLAUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:40:17 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15640 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLAUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:40:16 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the acpi tree with the pci tree
Date: Tue, 1 Dec 2009 13:40:19 -0700
User-Agent: KMail/1.9.10
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20091126132228.85a63dee.sfr@canb.auug.org.au> <200911301526.07220.bjorn.helgaas@hp.com>
In-Reply-To: <200911301526.07220.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912011340.21370.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 November 2009 03:26:05 pm Bjorn Helgaas wrote:
> On Wednesday 25 November 2009 07:22:28 pm Stephen Rothwell wrote:
> > Today's linux-next merge of the acpi tree got a conflict in
> > drivers/pci/hotplug/acpiphp_glue.c between commit
> > 204d49a5613a06eb2fa5c3b842a29b1336cc7995 ("PCI hotplug: move IOAPIC
> > support from acpiphp to ioapic driver") from the pci tree and commit
> > 2263576cfc6e8f6ab038126c3254404b9fcb1c33 ("ACPICA: Add post-order
> > callback to acpi_walk_namespace") from the acpi tree.
> > 
> > The former moved part of the code modified by the latter into another
> > file.  All the calls to acpi_walk_namespace() seem to have been removed
> > in this process.
> 
> I was on vacation last week, so couldn't respond earlier, sorry.
> 
> As you noticed, 204d49a56 removed some acpi_walk_namespace() calls.
> It removed calls to the old "pre-order only" version, while 263576cfc
> converted acpi_walk_namespace() to a new "pre-order and post-order"
> version.
> 
> This is conceptually simple because 204d49a56 is just removing uses
> of acpi_walk_namespace(), so we don't care at all whether it removes
> calls to the old or new version.  But I don't have enough git-fu to
> know how to fix this.

Has this been resolved already?  Is there anything I can do to help?

Bjorn
