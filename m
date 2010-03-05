Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab0CEKow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:44:52 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:58321 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0CEKou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:44:50 -0500
Message-ID: <4B90E071.1060903@Calva.COM>
Date: Fri, 05 Mar 2010 11:44:01 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++
 on different filesystems seems to deadlock in sync
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM> <20100303115015.GN5768@kernel.dk> <4B8E5805.30505@Calva.COM> <20100303120317.GP5768@kernel.dk> <20100303144241.GF21495@skl-net.de> <4B8FC9F8.1050700@Calva.COM> <20100304174239.GO7517@skl-net.de>
In-Reply-To: <20100304174239.GO7517@skl-net.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll wrote:
> On 15:55, John Hughes wrote:
>   
>>> That's the same patch you posted two weeks ago and on which Linus
>>> commented he thinks it is broken. He also proposed another, simpler
>>> patch (included below) which I'm running for a few days and which
>>> fixes the sync problem for me.
>>>  
>>>       
>> I've tried the "simpler patch" on my system and it makes no difference 
>> for me.
>>     
>
> Does it make no difference to Jens' patch, or no difference to an
> unpatched kernel?
>   
No difference to an unpatched kernel.  I didn't think of stacking the 
patches.
> BTW, switching from cfq to noop or deadline also improved things a
> bit for me.
>   
Will try that.

