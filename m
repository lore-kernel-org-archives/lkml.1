Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZBRS7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZBRS7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZBRS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:59:29 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:56956 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752268AbZBRS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:59:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rZ8F0V4sphjrm7qabgQXLRr+ufRUn4JN7r92GwgB+gQFcJhOA/+YCrV8gXM3QXbfr2pxloKgtwkGcWBgkj9JB0n6w0nYugW2h4UYx1OxsTLc8cgs39NtLohpAYDL4af6;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: ACPI hotplug panic with current git head
Date: Wed, 18 Feb 2009 10:59:26 -0800
User-Agent: KMail/1.9.10
References: <1231604250.3642.33.camel@localhost.localdomain> <200902131630.04858.jesse.barnes@intel.com> <499A46CC.1020102@jp.fujitsu.com>
In-Reply-To: <499A46CC.1020102@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181059.26779.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 16, 2009 9:10 pm Kenji Kaneshige wrote:
> Jesse Barnes wrote:
> > On Wednesday, January 28, 2009 3:47 am Kenji Kaneshige wrote:
> >> I made several patches to fix the wrong assumption described
> >> above. It is very difficult for me to check all the code that
> >> refers pci_bus->self. So I checked include/linux/pci-acpi.h and
> >> the code under drivers/pci/ only. And I made patches for the code
> >> like below:
> >>
> >>  - The code that clearly chooses host bridge operation or
> >>    PCI-to-PCI bridge operation based on pci_bus->self.
> >>
> >>  - The code that might cause endless loop if pci_bus->self is
> >>    not NULL on the PCI root bus.
> >
> > Kenji-san, can you re-send these to my private mail so I can apply them?
> > (Outlook/Exchange can't let plain text through without molesting it for
> > some reason.)
> >
> > Thanks,
>
> Sure. Resending the following patches. I made those patches against
> 2.6.29-rc2. I've confirmed they can be applied to 2.6.29-rc5.
>
>  - [PATCH 1/8] PCI/ACPI: fix wrong assumption in acpi_pci_get_bridge_handle
>  - [PATCH 2/8] PCI/ACPI: fix wrong assumption in
> acpi_find_root_bridge_handle - [PATCH 3/8] PCI hotplug: fix wrong
> assumption in acpi_get_hp_params_from_firmware - [PATCH 4/8] PCI hotplug:
> fix wrong assumption in acpi_get_hp_hw_control_from_firmware - [PATCH 5/8]
> PCI: fix wrong assumption in pci_find_upstream_pcie_bridge - [PATCH 6/8]
> PCI: fix wrong assumption in pci_read_bridge_bases
>  - [PATCH 7/8] PCI: fix wrong assumption in pci_get_interrupt_pin
>  - [PATCH 8/8] PCI: fix wrong assumption in pci_common_swizzle

James have you tested this set?  I didn't see your tested-by in the 
changelogs...  Just want to make sure if I'm going to send these to Linus for 
2.6.29.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
