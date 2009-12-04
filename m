Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZLDXVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZLDXVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbZLDXVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:21:45 -0500
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:45461 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752923AbZLDXVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:21:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rAFjONQw9J4qdmWHz1OHrpS+R9k25+RbATxv0bUJvsxqZ29k2vmhPI82pZNQryX/VABcqw8SCBZJb5rp/Bc+MotbGE0HdCjCdGOzRrBxtP2drPYIqBWujVgp/+b2147+;
Date: Fri, 4 Dec 2009 15:21:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 0/12] PCI run-time PM support (updated)
Message-ID: <20091204152103.779fa2a0@jbarnes-piketon>
In-Reply-To: <200911291632.44763.rjw@sisk.pl>
References: <200911160047.46299.rjw@sisk.pl>
	<200911291632.44763.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009 16:32:44 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
>  
> The following (updated) series of patches provides preliminary
> run-time power management support for PCI devices through ACPI and/or
> the native PCIe PME.
> 
> Some patches have been modified since the previous iteration and two
> new patches have been added.  Also, I've tested this patchset with
> the native PCIe PME mechanism using the r8169 driver on the MSI Wind
> U-100 (see the last patch for details).
> 
> [1/12] - Add flag for marking devices capable of generating wake-up
> events at run time 
> [2/12] - Add function for checking PME status of devices
>  
> [3/12] - Modify wake-up enable propagation so that it's done for PCIe
> devices too 
> [4/12] - PCIe PME root port service driver
> 
> [5/12][New] - "Don't use MSIs for PME signaling" switch for PCIe
>  
> [6/12] - ACPI GPE refcounting, from Matthew
>  
> [7/12] - ACPI drivers support for GPE refcounting, from Matthew
>  
> [8/12] - ACPI removal of the old GPE API, from Matthew
>  
> [9/12] - ACPI add fields for handling run-wake devices
>  
> [10/12] - PCI ACPI platform support for run-time power management
> 
> [11/12] - Runtime PM callbacks for the PCI bus type
> 
> [12/12] - Runtime PM support for r8169 (experimental)
> 
> If there are no objections, I think the patches [1-11/12] are ready
> for merging at this point.

Len, it sounds like this patchset is settling down.  Have you or one of
the ACPI folks had a chance to check out the ACPI GPE changes?  I can
take it all through my PCI tree if you're ok with it.

-- 
Jesse Barnes, Intel Open Source Technology Center
