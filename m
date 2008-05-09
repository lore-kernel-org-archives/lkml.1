Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbYEIAgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbYEIAgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYEIAgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:36:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:10262 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYEIAgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:36:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,457,1204531200"; 
   d="scan'208";a="279459421"
Date: Thu, 8 May 2008 17:28:59 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080508172859.4b0cd9af@appleyard>
In-Reply-To: <20080509001458.GA16082@srcf.ucam.org>
References: <20080508161008.59361de5@appleyard>
	<20080508233713.GB15377@srcf.ucam.org>
	<20080508163555.51380949@appleyard>
	<20080509001458.GA16082@srcf.ucam.org>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 01:14:58 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 08, 2008 at 04:35:55PM -0700, Kristen Carlson Accardi wrote:
> > On Fri, 9 May 2008 00:37:13 +0100
> > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > Just out of interest, is this set on laptop bays? (Are any of those even 
> > > native SATA yet?)
> > 
> > I haven't seen any yet that are.  Most of them are PATA.  I expect
> > that will change in the future.
> 
> Yeah. My vague concern would be that on laptops, we can probably power 
> down the port even if it's declared as being hotplug capable - we'll 
> probably get an out of band signal from ACPI anyway. Not an issue at the 
> moment, but possibly something we'll hit in future.
> 

well - when drive bays on laptops are able to be controlled by
AHCI, they may not actually use _EJ0 or send notifications anymore, 
since ACPI will not longer be necessary for hotplugging.  We'll have 
to see what happens.
