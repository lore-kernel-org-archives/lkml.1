Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYB1OL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYB1OL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYB1OLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:11:49 -0500
Received: from hall.aurel32.net ([88.191.38.19]:33098 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYB1OLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:11:48 -0500
Message-ID: <47C6C10E.9000300@aurel32.net>
Date: Thu, 28 Feb 2008 15:11:26 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
User-Agent: IceDove 1.5.0.14pre (X11/20080208)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, Adrian Bunk <bunk@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SSB] PCI core driver: use new SPROM data structure
References: <20080217200947.GH1403@cs181133002.pp.htv.fi> <20080218100126.GA22519@hall.aurel32.net> <20080218100257.GB22519@hall.aurel32.net> <200802181910.46581.mb@bu3sch.de>
In-Reply-To: <200802181910.46581.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch a écrit :
> On Monday 18 February 2008 11:02:57 Aurelien Jarno wrote:
>> Switch the SSB PCI core driver to the new SPROM data structure now that
>> the old one has been removed.
>>
>> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> 
> Acked-by: Michael Buesch <mb@bu3sch.de>
> 
> John, can you please apply this?

John, any news about this patch?

>> ---
>>  drivers/ssb/driver_pcicore.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
>> index 2faaa90..191db7a 100644
>> --- a/drivers/ssb/driver_pcicore.c
>> +++ b/drivers/ssb/driver_pcicore.c
>> @@ -362,7 +362,7 @@ static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
>>  	    chipid_top != 0x5300)
>>  		return 0;
>>  
>> -	if (bus->sprom.r1.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
>> +	if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
>>  		return 0;
>>  
>>  	/* The 200-pin BCM4712 package does not bond out PCI. Even when
>> -- 
>> 1.5.4.1
>>
> 
> 
> 


-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
