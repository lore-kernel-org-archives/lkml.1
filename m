Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZFDJVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZFDJVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZFDJVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:21:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51044 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFDJVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:21:46 -0400
Message-ID: <4A27927E.9090800@redhat.com>
Date: Thu, 04 Jun 2009 17:23:10 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [Patch 1/2] kbuild: two trivial fixes for check headers
References: <20090604080406.7005.27662.sendpatchset@localhost.localdomain> <20090604091519.GA9571@uranus.ravnborg.org>
In-Reply-To: <20090604091519.GA9571@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Jun 04, 2009 at 04:01:52AM -0400, Amerigo Wang wrote:
>   
>> Remove a useless 'extern' in an exported header.
>> Fix a comment headers_check.pl.
>>     
>
> These two patches has nothing in commom.
>   

They are both about kernel headers stuff.

>   
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>>
>> ------
>> diff --git a/include/mtd/jffs2-user.h b/include/mtd/jffs2-user.h
>> index fa94b0e..10dc7ef 100644
>> --- a/include/mtd/jffs2-user.h
>> +++ b/include/mtd/jffs2-user.h
>> @@ -18,7 +18,7 @@
>>  #undef je32_to_cpu
>>  #undef jemode_to_cpu
>>  
>> -extern int target_endian;
>> +int target_endian;
>>     
>
> You now declare a global variable named target_endian each time you include this file - which is wrong.
>   
Why? 'make headers_check' complains about it.

