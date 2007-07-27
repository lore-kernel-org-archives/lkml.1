Return-Path: <linux-kernel-owner+w=401wt.eu-S937073AbXG0Ufp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937073AbXG0Ufp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXG0Ufi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:35:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:39224 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbXG0Ufh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OWuH9OIr6qBTR0xjNHs/LpL3HL+ralIG3YUOxzpObmxKCaXrhZZIcfPHX5uHdJzNEStDfwbI62anWIAK2quyZs1Br0g0k2x+gOCe6J+rmi6yEoBUJmk3c+WNL8+4bUT8rD8fAXjbrQLdtc3dg7qkD24Gx+YEoNgYjC1x8+WnPcY=
Message-ID: <86802c440707271335y29ca79ccq844b5cb457bd2314@mail.gmail.com>
Date: Fri, 27 Jul 2007 13:35:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "Shaohua Li" <shaohua.li@intel.com>,
       "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
In-Reply-To: <200707271256.17025.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707271217.00164.bjorn.helgaas@hp.com>
	 <86802c440707271138k822077cl9dd9995ee2b9c7dd@mail.gmail.com>
	 <200707271256.17025.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Friday 27 July 2007 12:38:56 pm Yinghai Lu wrote:
> > On 7/27/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > On Wednesday 25 July 2007 08:21:06 pm Shaohua Li wrote:
> > > That doesn't help with Yinghai's PCI root ordering issue, of course.
> >
> > I could
> > sort the acpi_pci_roots before using it, in acpi_pci_register_driver()
>
> acpi_pci_register_driver() is only used by hotplug.  acpi_pci_root_add()
> does the pci_acpi_scan_root(), so sorting in acpi_pci_register_driver()
> won't affect that.

Not sure. will test that later.

>
> Can you give a more detailed example?  Maybe that would help me understand
> the problem you're seeing.
>
> And why is udev not sufficient to give the NICs persistent names?

yes. NIC on node1 become the eth0 instead of eth2.

YH
