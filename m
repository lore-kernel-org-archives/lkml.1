Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYARBnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYARBnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbYARBnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:43:14 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:46951 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbYARBnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:43:12 -0500
Date: Fri, 18 Jan 2008 01:42:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Thomas, Sujith" <sujith.thomas@intel.com>
Message-ID: <20080118014254.GA14818@srcf.ucam.org>
References: <1200556282.2935.122.camel@acpi-sony.sh.intel.com> <20080117122431.GA32133@srcf.ucam.org> <1200619900.2935.161.camel@acpi-sony.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200619900.2935.161.camel@acpi-sony.sh.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 6/10] ACPI: register ACPI Video LCD as generic thermal cooling device
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 09:31:40AM +0800, Zhang Rui wrote:

> Just like I don't think lcd should be used for ACPI thermal management
> before I saw it is listed in _TZD and intel_menlow requires to throttle
> it when overheating, why not let the individual drivers implement the
> callbacks if there is clearly a request to do this.
> And we can add this to the generic acpi_device struct then if this is a
> common feature for all ACPI devices.

It'll probably never be common for all ACPI devices, but it's already 
required for three types. I think that's a strong argument for making it 
generic.

> Well, you're right.
> But in order to throttle the lcd, this is reasonable, right?

Moving the common code into its own routine and then calling that from 
each of the others would probably work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
