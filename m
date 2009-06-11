Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZFKFXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZFKFXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbZFKFXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:23:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41234 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbZFKFW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:22:59 -0400
Message-ID: <4A309557.8040508@redhat.com>
Date: Thu, 11 Jun 2009 13:25:43 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.31 -mm merge plans
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org> <20090610190841.GT8633@ZenIV.linux.org.uk> <20090610121633.d678fc8b.akpm@linux-foundation.org> <4A305A99.70701@redhat.com> <20090611031005.GU8633@ZenIV.linux.org.uk>
In-Reply-To: <20090611031005.GU8633@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Thu, Jun 11, 2009 at 09:15:05AM +0800, Amerigo Wang wrote:
>   
>> Hi, Al.
>>
>> Just as what I said in the description of that patch, one only has  
>> extern functions that are _only_ used in another as function pointers.
>>     
>
> Er...  So what?  Amount of functions made static is not, per se, a
> useful metrics of anything.
>   
Not only about static, but also because they are used via function pointers.

Logically, it is better for these functions used via pointers to be kept in
the same file with the struct which holds these function pointers.

