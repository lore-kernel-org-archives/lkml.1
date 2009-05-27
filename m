Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZE0In5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZE0In5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZE0Int
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:43:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZE0Int (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:43:49 -0400
Message-ID: <4A1CFBCB.8020808@redhat.com>
Date: Wed, 27 May 2009 16:37:31 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rdunlap@xenotime.net, mingo@elte.hu
Subject: Re: [Patch 2/2] Doc: move Documentation/exception.txt into x86 subdir
References: <20090527072952.6279.72977.sendpatchset@localhost.localdomain>	 <20090527073001.6279.90725.sendpatchset@localhost.localdomain> <1243412698.3109.4.camel@localhost.localdomain>
In-Reply-To: <1243412698.3109.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Wed, 2009-05-27 at 03:28 -0400, Amerigo Wang wrote:
>   
>> exception.txt only explains the code on x86, so it's better to
>> move it into Documentation/x86 directory.
>>
>> This patch is on top of the previous one.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Ingo Molnar <mingo@elte.hu>
>>
>> ---
>> Index: linux-2.6/Documentation/exception.txt
>> ===================================================================
>> --- linux-2.6.orig/Documentation/exception.txt
>> +++ /dev/null
>>     
>
>   
>> Index: linux-2.6/Documentation/x86/extable.txt
>> ===================================================================
>> --- /dev/null
>> +++ linux-2.6/Documentation/x86/extable.txt
>>     
>
> What is the reason of this name change exception.txt -> extable.txt
>   
Hello,

Because this doc explains how exception tables work on x86, not the 
hardware concept
"exceptions" of x86 CPU, thus extable.txt is much more reasonable. :)


