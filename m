Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXCHAgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXCHAgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:36:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXCHAgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:36:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:16037 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXCHAf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:35:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,262,1170662400"; 
   d="scan'208"; a="54718159:sNHT18811899"
Message-ID: <45EF5A69.8050306@intel.com>
Date: Wed, 07 Mar 2007 16:35:53 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?=22J=2EA=2E?= =?ISO-8859-1?Q?_Magall=F3n=22?= 
	<jamagallon@ono.com>,
       linux-kernel@vger.kernel.org
Subject: Re: e1000 oops on boot [Re: 2.6.21-rc2-mm2]
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>	<20070308010323.58b80d96@werewolf-wl>	<20070307162315.76f2a60b.akpm@linux-foundation.org> <20070307162853.0337e643.randy.dunlap@oracle.com>
In-Reply-To: <20070307162853.0337e643.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2007 00:35:58.0230 (UTC) FILETIME=[BD5B4360:01C76119]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 7 Mar 2007 16:23:15 -0800 Andrew Morton wrote:
> 
>> The below will apppear in -rc3-mm1 (hopefully later today) and it will
>> hopefully fix that crash.
>>
>>
>> From: Auke Kok <auke-jan.h.kok@intel.com>
>>
>> ---
>>
>>  drivers/net/e1000/e1000_main.c |   66 +++++++++++++++++++++----------
>>  1 files changed, 45 insertions(+), 21 deletions(-)
>>
>> diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq drivers/net/e1000/e1000_main.c
>> --- a/drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq
>> +++ a/drivers/net/e1000/e1000_main.c
>> @@ -522,14 +522,15 @@ e1000_release_manageability(struct e1000
>>  	}
>>  }
> 
> Auke:
> 
> Below, please s/@adapter =/@adapter:/ to make it be correct
> kernel-doc notation.

ah, sorry about that :)

I'll adjust it later when doing some more cleanups. Thanks for the pointer.

Auke
