Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXKTCR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXKTCR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbXKTCLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:11:07 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:53621 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983AbXKTCLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:11:04 -0500
Date: Tue, 20 Nov 2007 02:04:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Message-ID: <20071120020402.GA26446@srcf.ucam.org>
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119233225.GA6931@us.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 03:32:25PM -0800, Gary Hade wrote:

> Alex, What I was trying to suggest is a boot-time kernel option, 
> not a kernel configuration option.  The basic idea is to give
> the user (with a single binary kernel) the ability to include
> your ACPI-PCI slot driver feature changes only when they are
> really needed.  In addition to reducing the number of
> system/PCI hotplug driver combinations where your changes
> would need to be validated, I believe would also help 
> alleviate other worries (e.g. Andi Kleen's memory consumption
> concern).  I believe this goal could also be achieved with the
> kernel config option by making the pci_slot module runtime
> loadable with the PCI hotplug drivers only visiting your new
> code when the pci_slot driver is loaded, although I think this
> would be more difficult to implement.

If we're compiling something into the kernel, the default behaviour 
should be for the functionality to be turned on unless the user 
overrides it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
