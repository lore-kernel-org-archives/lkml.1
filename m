Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYF0Qk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYF0Qk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbYF0QkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:40:24 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:32574 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbYF0QkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:40:22 -0400
Date: Fri, 27 Jun 2008 12:39:45 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Bunk <bunk@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080627163945.GA26130@il.ibm.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-2-git-send-email-joerg.roedel@amd.com> <20080627142558.GG18644@cs181140183.pp.htv.fi> <878wwrq6im.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wwrq6im.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 04:47:29PM +0200, Andi Kleen wrote:

> Also it should ideally describe that there is a trade off between
> reliability and performance with IOMMU enabled.

I agree that there's a performance tradeoff with current generation
hardware and ingerfaces, but it wouldn't be fair to single out a
single IOMMU implementation ;=)

config DMAR
	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
	depends on X86_64 && PCI_MSI && ACPI && EXPERIMENTAL
	help
	  DMA remapping (DMAR) devices support enables independent address
	  translations for Direct Memory Access (DMA) from devices.
	  These DMA remapping devices are reported via ACPI tables
	  and include PCI device scope covered by these DMA
	  remapping devices.

Cheers,
Muli
