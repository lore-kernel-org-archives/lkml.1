Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZFKBMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZFKBMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 21:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZFKBMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 21:12:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38015 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZFKBMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 21:12:22 -0400
Message-ID: <4A305A99.70701@redhat.com>
Date: Thu, 11 Jun 2009 09:15:05 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.31 -mm merge plans
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org>	<20090610190841.GT8633@ZenIV.linux.org.uk> <20090610121633.d678fc8b.akpm@linux-foundation.org>
In-Reply-To: <20090610121633.d678fc8b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc's added)
>
> On Wed, 10 Jun 2009 20:08:41 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
>   
>> On Wed, Jun 10, 2009 at 11:51:40AM -0700, Andrew Morton wrote:
>>
>>     
>>> proc-merge-arrayc-into-basec.patch
>>> proc-merge-arrayc-into-basec-checkpatch-fixes.patch
>>>       
>> I'm not sure that there's any point in that.  Sure, we can slap two
>> files together; what the hell for?  Both are quite large, there's
>> a (relatively) sane separation of code between them (misc. files
>> contents in /proc/<pid>/ vs. directory structure and symlinks in
>> there, more or less) and I don't see any benefit in mashing them
>> together.  Up to Alexey, but IMO that's pointless.
>>     
>
> No strong opinions here.
>   

Hi, Al.

Just as what I said in the description of that patch, one only has 
extern functions that are _only_ used in another as function pointers.

And the size of code can't be a reason why they are seperated, we have
much more source files larger than this one. :)

Thanks.


