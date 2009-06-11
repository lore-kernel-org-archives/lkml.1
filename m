Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbZFKTXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbZFKTXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbZFKTXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:23:09 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18231 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZFKTXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:23:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH v3 00/12] Dynamic ACPI-PCI binding
Date: Thu, 11 Jun 2009 13:22:59 -0600
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20090610194714.28982.51363.stgit@bob.kio>
In-Reply-To: <20090610194714.28982.51363.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111323.01358.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009 01:55:04 pm Alex Chiang wrote:
> Alex Chiang (12):
>       ACPI: kill acpi_get_physical_pci_device()
>       ACPI: video: convert to acpi_get_pci_dev
>       ACPI: kill acpi_get_pci_id
>       PCI Hotplug: acpiphp: convert to acpi_get_pci_dev
>       ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind
>       ACPI: simplify acpi_pci_irq_del_prt() API
>       ACPI: simplify acpi_pci_irq_add_prt() API
>       ACPI: eviscerate pci_bind.c
>       ACPI: rearrange acpi_pci_bind/acpi_pci_unbind in pci_bind.c
>       ACPI: Introduce acpi_get_pci_dev()
>       ACPI: Introduce acpi_is_root_bridge()
>       ACPI: make acpi_pci_bind() static
> 
>  drivers/acpi/glue.c                |   40 -----
>  drivers/acpi/pci_bind.c            |  313 ++++--------------------------------
>  drivers/acpi/pci_irq.c             |   17 +-
>  drivers/acpi/pci_root.c            |  112 ++++++++++++-
>  drivers/acpi/video.c               |    6 -
>  drivers/acpi/video_detect.c        |    9 +
>  drivers/pci/hotplug/acpi_pcihp.c   |   40 -----
>  drivers/pci/hotplug/acpiphp_glue.c |   27 +--
>  include/acpi/acpi_bus.h            |    2 
>  include/acpi/acpi_drivers.h        |   10 -
>  include/linux/pci_hotplug.h        |    1 
>  11 files changed, 176 insertions(+), 401 deletions(-)

This is a beautiful piece of work.

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
