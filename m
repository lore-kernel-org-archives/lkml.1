Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbXCRBzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbXCRBzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 21:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXCRBzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 21:55:24 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:41771 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXCRBzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 21:55:23 -0400
Message-ID: <45FC9B54.4080209@student.ltu.se>
Date: Sun, 18 Mar 2007 02:52:20 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: akpm@linux-foundation.org, davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/agp: Convert to generic boolean
References: <20070317234303.14375.43303.sendpatchset@thinktank.campus.ltu.se> <1174178837.15270.13.camel@localhost>
In-Reply-To: <1174178837.15270.13.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please use "Reply All"

Joe Perches wrote:
> On Sun, 2007-03-18 at 00:45 +0100, Richard Knutsson wrote:
>   
>> diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
>> index e6c534e..3d57e9f 100644
>> --- a/drivers/char/agp/amd-k7-agp.c
>> +++ b/drivers/char/agp/amd-k7-agp.c
>> @@ -308,9 +308,9 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
>>  		j++;
>>  	}
>>  
>> -	if (mem->is_flushed == FALSE) {
>> +	if (!mem->is_flushed) {
>>  		global_cache_flush();
>> -		mem->is_flushed = TRUE;
>> +		mem->is_flushed = true;
>>  	}
>>     
>
> perhaps a generic.c / agp.h function?
>   
Sound like a good idea (not in a boolean cleanup-patch thou)
Would you mind making that patch?

Richard Knutsson

