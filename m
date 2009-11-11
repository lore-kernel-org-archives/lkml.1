Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZKKUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZKKUFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZKKUFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:05:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50235 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZKKUFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:05:35 -0500
Date: Wed, 11 Nov 2009 20:05:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, shaohua.li@intel.com, bjorn.helgaas@hp.com
Subject: Re: [PATCH] pci: Updates to Rafael's runtime PCI PM patch set
Message-ID: <20091111200503.GA22328@srcf.ucam.org>
References: <200910090051.50932.rjw@sisk.pl> <1257806529-6535-1-git-send-email-mjg@redhat.com> <200911112058.20331.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911112058.20331.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 08:58:20PM +0100, Rafael J. Wysocki wrote:

> The PME was supposed to be turned on by pci_prepare_to_sleep().
> I guess it wasn't in practice?

Only if the device is set as a wakeup device, which seems messy. Though 
there may need to be a check there to avoid duplicate PME setup.

> Generally, some parts of it belong to the
> "PCI PM: Run-time callbacks for PCI bus type" patch and the others belong
> to "PCI / ACPI PM: Platform support for PCI PME wake-up" patch.  Should I fold
> the changes into them?

Feel free!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
