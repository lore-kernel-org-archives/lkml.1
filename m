Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXDTWmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXDTWmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXDTWmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:42:49 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbXDTWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:42:46 -0400
Date: Fri, 20 Apr 2007 15:41:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andy Currid <ACurrid@nvidia.com>
Subject: Re: [PATCH v3] hpet: Detect hidden HPET on NVidia motherboards
Message-Id: <20070420154157.63c09794.akpm@linux-foundation.org>
In-Reply-To: <1176847068.4865.3.camel@dual.local>
References: <1176708094.22969.7.camel@dual.local>
	<p734png6s1t.fsf@bingen.suse.de>
	<Pine.OSF.4.64.0704162337320.487506@kosh.hut.fi>
	<20070416214042.GB25508@one.firstfloor.org>
	<1176847068.4865.3.camel@dual.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 00:57:48 +0300
Mikko Tiihonen <mikko.tiihonen@iki.fi> wrote:

> Enables HPET for NVidia motherboards with broken BIOS. The patch reads
> the HPET address from the pci config space. The patch should also work
> if ACPI is disabled.
> 
> The new quirk activates use of HPET only run if
> - CONFIG_HPET_NFORCE_DETECT is enabled
> - nohpet boot option is not set
> - main chipset is from NVidia
> - ACPI tables do not list HPET
> - matching PCI ID for device with HPET is found
> - BIOS has set up the HPET to some address
> - there is no other resource allocated at the HPET address
> 
> This is true at least for some Asus, Gigabyte and DFI motherboards.
> 
> Patch is against 2.6.21-rc6-git7 but should apply cleanly to most
> kernels.

I looked at applying this but

a) there have been rather a lot of underlying changes in Andi's devel tree and

b) we still haven't heard from Andy?

