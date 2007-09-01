Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbXIAKiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbXIAKiC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:38:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXIAKhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:37:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:17286 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbXIAKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KgqmmmxpG1/0wTajep2xKNTFDbjIvTkRP1HnqMlbm7hR5HvlUIKIccIoEeA4UlqKblD7yj1GgsffKye7o5MNWPYUk/W42zLXsSTR6YDGQuw2cbd8wxALE40YBHTSvHBJLx0MAXLfiF1iSHbPBA6CnoVNxfnqyt1Qlp1vi2y3KGs=
Date: Sat, 1 Sep 2007 14:37:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Grant Wilson <grant.wilson@zen.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc5 - oops
Message-ID: <20070901103746.GB7425@cvg>
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org> <20070901101110.038835c2@worthy.swandive.local> <20070901102050.GA7425@cvg> <46D93FBB.10601@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D93FBB.10601@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jeff Garzik - Sat, Sep 01, 2007 at 06:32:27AM -0400]
> Cyrill Gorcunov wrote:
>> test this, does it help?
>> 		Cyrill
>> ---
>> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
>> index e40c94f..8031697 100644
>> --- a/drivers/ata/ata_piix.c
>> +++ b/drivers/ata/ata_piix.c
>> @@ -1187,6 +1187,7 @@ static void piix_iocfg_bit18_quirk(struct pci_dev 
>> *pdev)
>>  				DMI_MATCH(DMI_PRODUCT_NAME, "M570U"),
>>  			},
>>  		},
>> +		{}
>>  	};
>
>
> heh, you beat me to it.  That should indeed fix it.
>
> 	Jeff
>
>

Don't swear on me it was not intended ;)

So Jeff, make the real patch then (and btw I think
using braces with a space between does look more
elegant ;)

		Cyrill

