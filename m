Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZGXVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZGXVib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZGXVia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:38:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:29756 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbZGXVi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:38:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,266,1246863600"; 
   d="scan'208";a="477805543"
Date: Fri, 24 Jul 2009 14:38:27 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/2] PCI Hotplug: acpiphp: get pci_bus from acpi
 handle correctly
Message-ID: <20090724143827.31b4c37d@jbarnes-g45>
In-Reply-To: <20090723230305.4247.81288.stgit@bob.kio>
References: <20090723230026.4247.12759.stgit@bob.kio>
	<20090723230305.4247.81288.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 17:03:05 -0600
Alex Chiang <achiang@hp.com> wrote:

> We cannot simply call acpi_get_pci_dev() on any random ACPI handle
> and hope that it works, because a PCI root bridge may not have
> an associated struct pci_dev.
> 
> This is allowed per the PCI specification, and is referred to as a
> non-materialized bridge.
> 
> So, depending on the type of PCI bridge that the handle points to,
> use the appropriate interface to return the struct pci_bus correctly.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---

I put these in my linux-next branch, just because I'm really
conservative about the current release.

If we hear of boxes in the wild getting bitten by the non-materialized
bit, we can push this set back to stable.

-- 
Jesse Barnes, Intel Open Source Technology Center
