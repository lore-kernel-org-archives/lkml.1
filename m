Return-Path: <linux-kernel-owner+w=401wt.eu-S1422664AbXBOXPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422664AbXBOXPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422665AbXBOXPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:15:01 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47366 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422664AbXBOXPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:15:00 -0500
Message-ID: <45D4E96F.7080805@us.ibm.com>
Date: Thu, 15 Feb 2007 15:14:55 -0800
From: Vara Prasad <prasadav@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 00/05] Linux Kernel Markers - kernel 2.6.20
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> 	<20070214231201.20918c6b.akpm@linux-foundation.org> 	<y0mvei330ee.fsf@ton.toronto.redhat.com> <20070215141841.6eed5fbb.akpm@linux-foundation.org>
In-Reply-To: <20070215141841.6eed5fbb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>On 15 Feb 2007 10:28:57 -0500
>fche@redhat.com (Frank Ch. Eigler) wrote:
>
>  
>
>>akpm wrote:
>>
>>    
>>
>>>[...]  And what can I do with these markers?  And once I've done it,
>>>are there any userspace applications I can use to get the data out
>>>in human-usable form?  [...]
>>>      
>>>
>>The LTTng user-space programs use it today.  Systemtap used to support
>>the earlier marker prototype and will be rapidly ported over to this
>>new API upon acceptance.
>>
>>    
>>
>
>That's good.
>
>It would be beneficial if some people from those projects could spare the
>cycles to carefully review and runtime test this code.
>  
>

Sure, as soon as SystemTap translator supports this new marker mechanism 
we will give it a spin and report results.

>Also, I'm not 100% clear on where we ended up with the huge
>static-vs-dynamic flamewar.  Did everyone end up happy?  Is this patchset a
>reasonable compromise?  Or do we need a rematch?
>  
>
 From my view this is a good compromise. We all realized in that long 
discussion thread that we need a way to mark the code in the middle of 
functions that can later be activated dynamically. Mathieu's current 
implementation meets that goal. I will be happy to see this in.

Thanks,
Vara Prasad


