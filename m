Return-Path: <linux-kernel-owner+w=401wt.eu-S966859AbXHIRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966859AbXHIRGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbXHIRGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:06:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:52829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765953AbXHIRGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:06:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,241,1183359600"; 
   d="scan'208";a="115572169"
Message-ID: <46BB4992.2020504@intel.com>
Date: Thu, 09 Aug 2007 10:06:26 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       e1000-devel@lists.sourceforge.net, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [E1000-devel] 2.6.23-rc2-mm1: e1000e global symbols must be renamed
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070809135131.GN6997@stusta.de>
In-Reply-To: <20070809135131.GN6997@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2007 17:06:30.0866 (UTC) FILETIME=[A1955320:01C7DAA7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
>> ...
>> - There is a new e1000 driver in git-netdev-all, called e1000e.  I'm sure
>>   the developers would like it tested.  Please cc netdev@vger.kernel.org on
>>   any reports.
>> ...
>> Changes since 2.6.23-rc2-mm1:
>> ...
>>  git-netdev-all.patch
>> ...
>>  git trees
>> ...
> 
> <--  snip  -->
> 
> ...
>   LD      drivers/net/built-in.o
> drivers/net/e1000e/built-in.o: In function `e1000_read_mac_addr':
> (.text+0x3470): multiple definition of `e1000_read_mac_addr'
> drivers/net/e1000/built-in.o:(.text+0xb6cc): first defined here
> drivers/net/e1000e/built-in.o: In function `e1000_set_ethtool_ops':
> (.text+0x594d): multiple definition of `e1000_set_ethtool_ops'
> drivers/net/e1000/built-in.o:(.text+0xc97a): first defined here
> ...
> make[3]: *** [drivers/net/built-in.o] Error 1

ack, I'll step on that and make it go away :)

Auke
