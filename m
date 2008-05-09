Return-Path: <linux-kernel-owner+w=401wt.eu-S1765633AbYEIRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765633AbYEIRWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYEIRWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:22:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:14094 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760996AbYEIRV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,461,1204531200"; 
   d="scan'208";a="326419099"
Date: Fri, 9 May 2008 10:14:35 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080509101435.1532364a@appleyard>
In-Reply-To: <20080509161456.GF6957@csclub.uwaterloo.ca>
References: <20080508161008.59361de5@appleyard>
	<20080508233713.GB15377@srcf.ucam.org>
	<20080509155830.GE6957@csclub.uwaterloo.ca>
	<20080509160641.GA30219@srcf.ucam.org>
	<20080509161456.GF6957@csclub.uwaterloo.ca>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 12:14:56 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Fri, May 09, 2008 at 05:06:41PM +0100, Matthew Garrett wrote:
> > Genuinely SATA, or PATA bridged to SATA?
> 
> SATA drives using intel 945GM chipset which has two native SATA ports.
> 

Most 945s I've seen in implementation have the DVD/drive bay as PATA
bridged to SATA.

But, this is an irrelevant conversation.  

For drives controlled by ata_piix, they will continue with the 
"hotplug all the time" policy that the rest of libata has until 
someone else patches that driver to mark the drives not hotpluggable
based on whatever method they want to use to determine that.  As we 
get more laptops implementing pure SATA drive bays we can refine 
the patch to use ACPI events to turn the phy back on if 
laptop vendors continue to use ACPI to generate insert/remove events.
