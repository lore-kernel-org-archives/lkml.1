Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbZH0Ijg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbZH0Ijg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZH0Ijf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:39:35 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:37699 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZH0Ijf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:39:35 -0400
Message-ID: <4A96463E.5080002@corp.free.fr>
Date: Thu, 27 Aug 2009 10:39:26 +0200
From: Yohan <ytordjman@corp.free.fr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: VM issue causing high CPU loads
References: <4A92A25A.4050608@yohan.staff.proxad.net> <20090824162155.ce323f08.akpm@linux-foundation.org>
In-Reply-To: <20090824162155.ce323f08.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 24 Aug 2009 16:23:22 +0200
> Yohan <kernel@yohan.staff.proxad.net> wrote:
>   
>> Hi,
>>
>>     Is someone have an idea for that :
>>
>>         http://bugzilla.kernel.org/show_bug.cgi?id=14024
>>     
> Please generate a kernel profile to work out where all the CPU tie is
> being spent.  Documentation/basic_profiling.txt is a starting point.
>   
I post some new reports, it seems that the problem is in  
rpcauth_lookup_credcache ...

for information, this is an imap mail server that mounts ~10 netapp over 
~300 mountpoints..

Thanks
Yohan
