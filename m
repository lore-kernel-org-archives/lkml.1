Return-Path: <linux-kernel-owner+w=401wt.eu-S934385AbYEIAPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934385AbYEIAPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbYEIAPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:15:18 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:37129 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbYEIAPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:15:14 -0400
Date: Fri, 9 May 2008 01:14:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20080509001458.GA16082@srcf.ucam.org>
References: <20080508161008.59361de5@appleyard> <20080508233713.GB15377@srcf.ucam.org> <20080508163555.51380949@appleyard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508163555.51380949@appleyard>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] ata: ahci: power off unused ports
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 04:35:55PM -0700, Kristen Carlson Accardi wrote:
> On Fri, 9 May 2008 00:37:13 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Just out of interest, is this set on laptop bays? (Are any of those even 
> > native SATA yet?)
> 
> I haven't seen any yet that are.  Most of them are PATA.  I expect
> that will change in the future.

Yeah. My vague concern would be that on laptops, we can probably power 
down the port even if it's declared as being hotplug capable - we'll 
probably get an out of band signal from ACPI anyway. Not an issue at the 
moment, but possibly something we'll hit in future.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
