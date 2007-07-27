Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbXG0S6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbXG0S6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761139AbXG0S54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:57:56 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:39477 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760975AbXG0S5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:57:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Fri, 27 Jul 2007 12:56:16 -0600
User-Agent: KMail/1.9.6
Cc: "Shaohua Li" <shaohua.li@intel.com>,
       "=?iso-8859-1?q?S=E9bastien?= =?iso-8859-1?q?_Dugu=E9?=" 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707271217.00164.bjorn.helgaas@hp.com> <86802c440707271138k822077cl9dd9995ee2b9c7dd@mail.gmail.com>
In-Reply-To: <86802c440707271138k822077cl9dd9995ee2b9c7dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271256.17025.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 12:38:56 pm Yinghai Lu wrote:
> On 7/27/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Wednesday 25 July 2007 08:21:06 pm Shaohua Li wrote:
> > That doesn't help with Yinghai's PCI root ordering issue, of course.
> 
> I could
> sort the acpi_pci_roots before using it, in acpi_pci_register_driver()

acpi_pci_register_driver() is only used by hotplug.  acpi_pci_root_add()
does the pci_acpi_scan_root(), so sorting in acpi_pci_register_driver()
won't affect that.

Can you give a more detailed example?  Maybe that would help me understand
the problem you're seeing.

And why is udev not sufficient to give the NICs persistent names?

Bjorn
