Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYCJU0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYCJU0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYCJU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:26:41 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:59108
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYCJU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:26:40 -0400
Message-ID: <47D5A793.9070105@microgate.com>
Date: Mon, 10 Mar 2008 15:26:43 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink drivers bool conversion
References: <1205046574.656.37.camel@localhost>	 <47D3FCF6.70908@microgate.com>  <1205092170.656.59.camel@localhost> <1205114703.656.115.camel@localhost>
In-Reply-To: <1205114703.656.115.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sun, 2008-03-09 at 12:49 -0700, Joe Perches wrote:
>> diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
>> index ddc74d1..abf3c37 100644
>> --- a/drivers/char/synclink.c
>> +++ b/drivers/char/synclink.c
>> @@ -5413,9 +5410,9 @@ static void usc_process_rxoverrun_sync( struct mgsl_struct *info )
>>  
>>  		if ( !start_of_frame_found )
>>  		{
>> -			start_of_frame_found = TRUE;
>> +			start_of_frame_found = true;
>>  			frame_start_index = end_index;
>> -			end_of_frame_found = FALSE;
>> +			end_of_frame_found = true;
>>  		}
>>  
>>  		if ( buffer_list[end_index].status )
> 
> end_of_frame_found should be false

OK the patch checks out (with the above fix).

Post the updated patch with a CC to Andrew
and I'll post an Acked-by response.

-- 
Paul Fulghum
Microgate Systems, Ltd.
