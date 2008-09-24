Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYIXShp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYIXShp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYIXShd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:37:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:20480 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYIXShc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:37:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,302,1220252400"; 
   d="scan'208";a="383987158"
Message-ID: <48DA88EB.6030601@intel.com>
Date: Wed, 24 Sep 2008 11:37:31 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: John Gumb <john.gumb@tandberg.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: D945GCLF  intel atom board & r8169 ethernet broken in linux-2.6.27-rc5??
References: <9F6ACAE02B6DD040A1E259977622CFDB03F5BCCB@oslexcp1.eu.tandberg.int>
In-Reply-To: <9F6ACAE02B6DD040A1E259977622CFDB03F5BCCB@oslexcp1.eu.tandberg.int>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2008 18:37:31.0770 (UTC) FILETIME=[9ABA25A0:01C91E74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Gumb wrote:
> Hi
> 
> I have an Intel Atom D945GCLF based system. It has a realtek RTL8101E
> PCI network interface.
> 
> With linux-2.6.27-rc4 - everything seems fine. I think we've been
> working OK since 2.6.26ish.
> 
> With linux-2.6.27-rc5, "ifconfig eth0" just hangs. lspci -vvx reports,
> after loading the driver,
> 
>> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E
> PCI Express Fast Ethernet controller (rev ff) (prog-if ff)
>>       !!! Unknown header type 7f
> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  
> 
> Before I load the driver lspci -vvx looks OK.
> 
> I do not have (much) time to look into this any further but hopefully
> this might help someone.
> 
> I know there are problems with this device on the atom board
> particularly around warm start but thus far I seem to have avoided this
> issue.
> 
> A cold start in this case does not help.
> 
> Lspci.bad comes from -rc5 with the r8169 driver loaded.
> Lspci.good comes from -rc4 with the r8169 driver loaded


did you check if falling back to the older kernel makes the device work again?
