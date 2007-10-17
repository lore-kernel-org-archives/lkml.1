Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbXJQXP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbXJQXP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759661AbXJQXPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:15:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:50675 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbXJQXPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:15:41 -0400
Message-ID: <471699A0.3060303@tmr.com>
Date: Wed, 17 Oct 2007 19:24:16 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Al Boldi <a1426z@gawab.com>, Patrick McHardy <kaber@trash.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
References: <200710120031.42805.a1426z@gawab.com> <470EF994.4080403@trash.net> <200710120837.18152.a1426z@gawab.com> <47168EA1.1080300@tmr.com>
In-Reply-To: <47168EA1.1080300@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:

>>>> If not, then shouldn't the filter table be obsoleted to avoid 
>>>> confusion?
>>> That would probably confuse people. Just don't use it if you don't
>>> need to.
>>
> That is a most practical suggestion.
> 
>> The problem is that people think they are safe with the filter table, 
>> when in fact they need the prerouting chain to seal things.  Right now 
>> this is only possible in the mangle table.
>>
> I'm not sure what you think is unsafe about using the filter table, and 
> the order of evaluation issues certainly seem to suggest that some 
> actions would take a major rethink at least. Perhaps you could avoid 
> breaking all of the setups which currently work, rather than force 
> everyone to do things differently because you feel that your way is better.
> 
It was my intention to suggest that unintentional breakage of existing 
setups should be avoided, not that removing the filter table was some 
evil plot. ;-)
On rereading my original post I failed to make that clear, please take 
it as intended.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
