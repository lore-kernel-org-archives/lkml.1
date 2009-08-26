Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZHZLzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZHZLzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZHZLzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:55:37 -0400
Received: from yohan.staff.proxad.net ([213.228.1.71]:53915 "EHLO
	yohan.staff.proxad.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbZHZLzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:55:36 -0400
Message-ID: <4A9522B6.7060607@yohan.staff.proxad.net>
Date: Wed, 26 Aug 2009 13:55:34 +0200
From: Yohan <kernel@yohan.staff.proxad.net>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: VM issue causing high CPU loads
References: <4A92A25A.4050608@yohan.staff.proxad.net> <20090824162155.ce323f08.akpm@linux-foundation.org> <20090826110809.GG10955@csn.ul.ie>
In-Reply-To: <20090826110809.GG10955@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Mon, Aug 24, 2009 at 04:21:55PM -0700, Andrew Morton wrote:
>   
>> On Mon, 24 Aug 2009 16:23:22 +0200
>> Yohan <kernel@yohan.staff.proxad.net> wrote:
>>     
>>> Hi,
>>>
>>>     Is someone have an idea for that :
>>>
>>>         http://bugzilla.kernel.org/show_bug.cgi?id=14024
>>>       
>> Please generate a kernel profile to work out where all the CPU tie is
>> being spent.  Documentation/basic_profiling.txt is a starting point.
>>     
> In the absense of a profile, here is a total stab in the dark. Is this a
> NUMA machine? 
This is a Intel(R) Xeon(R) CPU E5520 on Dell R610
> If so, is /proc/sys/vm/zone_reclaim_mode set to 1 and does
> setting it to 0 help?
>   
The value is already 0...


Thanks
