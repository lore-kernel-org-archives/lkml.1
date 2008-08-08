Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYHHARb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYHHARb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYHHARG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:17:06 -0400
Received: from gw.goop.org ([64.81.55.164]:46243 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbYHHARF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:17:05 -0400
Message-ID: <489B9072.8020107@goop.org>
Date: Thu, 07 Aug 2008 17:16:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ehabkost@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make PFN_PHYS return a properly-formed physical address
References: <489B6B40.5050705@goop.org>	<20080807145648.ab3dfa90.akpm@linux-foundation.org>	<489B72C3.30603@goop.org>	<20080807162741.8dfcd336.akpm@linux-foundation.org>	<489B8908.2010007@goop.org> <20080807170617.79ca3ce7.akpm@linux-foundation.org>
In-Reply-To: <20080807170617.79ca3ce7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 07 Aug 2008 16:45:12 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Shall we go with just using plain u64 (or unsigned long long if we want 
>> a really consistent type) in the meantime, and then waffle about 
>> introducing a new type everywhere?
>>
>> Or we could redefine resource_size_t to be big enough to refer to any 
>> resource, including all memory.  It's close to being that anyway.
>>     
>
> We could do
>
> 	typedef resource_size_t jeremy_thing_t;
>
> for now and worry about it later if the need arises, perhaps.
>   

OK, I'll revise and repost.

Hm, curiously, the two arches which care most about this issue (x86 and 
powerpc) already have phys_addr_t...

I guess we don't want CONFIG_ARCH_HAVE_PHYS_ADDR_T...

    J
