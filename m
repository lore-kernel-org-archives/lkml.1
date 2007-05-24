Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbXEXWNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbXEXWNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXEXWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:13:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:17680 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXEXWNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="247023087"
Message-ID: <46560E04.2090500@intel.com>
Date: Thu, 24 May 2007 15:13:24 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-acpi@vger.kernel.org
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524220816.GC23214@khazad-dum.debian.net>
In-Reply-To: <20070524220816.GC23214@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2007 22:13:43.0030 (UTC) FILETIME=[CA339960:01C79E50]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 24 May 2007, Miklos Szeredi wrote:
>> Tried nmi_watchdog=1, but then the machine locks up hard shortly after
>> boot.
> 
> NMIs in some thinkpads are bad trouble, they lock up the blasted IBM/Lenovo
> SMBIOS if they happen to hit it while it is servicing a SMI, and thinkpads
> do SMIs like crazy.

there's also a L1 ASPM issue with the e1000 chipset in the way (for T60/X60 
only). Make sure you are using 2.6.21 or newer. See netdev archives for more on 
that.

Auke
