Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXGNHdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXGNHdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXGNHdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:33:13 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:64716 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXGNHdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:33:12 -0400
Date: Sat, 14 Jul 2007 01:35:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 5/7] ICH Force HPET: ICH5 quirk to force detect enable
In-reply-to: <fa.GJG5uLURdrisg2rJw413ItLjGTg@ifi.uio.no>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Message-id: <46987CAD.9020209@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GJG5uLURdrisg2rJw413ItLjGTg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> 
> force_enable hpet for ICH5.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> ---
>  arch/i386/kernel/hpet.c   |    2 
>  arch/i386/kernel/quirks.c |  101 +++++++++++++++++++++++++++++++++++++++++++++-
>  include/asm-i386/hpet.h   |    2 
>  include/linux/pci_ids.h   |    1 
>  4 files changed, 103 insertions(+), 3 deletions(-)
> 

According to some reports, and a quick test I did on my laptop, this 
same method appears to work on the ICH4 chipset, even though the HPET is 
not documented on that chipset. Does Intel have any info on HPET support 
on ICH4 and whether there's any reason we should not force enable it 
there as well?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

