Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbZDBJEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbZDBJEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934133AbZDBJDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:03:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45001 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436AbZDBJDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:03:44 -0400
Message-ID: <49D47F64.3020709@redhat.com>
Date: Thu, 02 Apr 2009 12:03:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Anthony Liguori <anthony@codemonkey.ws>, andi@firstfloor.org,
       ghaskins@novell.com, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402030935.GA27836@gondor.apana.org.au> <49D45F59.9030100@redhat.com> <20090402085411.GA29967@gondor.apana.org.au>
In-Reply-To: <20090402085411.GA29967@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Thu, Apr 02, 2009 at 09:46:49AM +0300, Avi Kivity wrote:
>   
>> I don't understand this.  If we had good interfaces, all that userspace  
>> would do is translate guest physical addresses to host physical  
>> addresses, and translate the guest->host protocol to host API calls.  I  
>> don't see anything there that benefits from being in the kernel.
>>
>> Can you elaborate?
>>     
>
> I think Greg has expressed it clearly enough.
>
> At the end of the day, the numbers speak for themselves.  So if
> and when there's a user-space version that achieves the same or
> better results, then I will change my mind :)
>   

Like Anthony said, the problem is with the kernel->user interfaces.  We 
won't have a good user space virtio implementation until that is fixed.

-- 
error compiling committee.c: too many arguments to function

