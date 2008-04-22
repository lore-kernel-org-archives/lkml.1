Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbYDVOrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbYDVOrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYDVOrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:47:43 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35066
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYDVOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:47:41 -0400
Message-ID: <480DFA8A.1050003@qumranet.com>
Date: Tue, 22 Apr 2008 17:47:38 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>	 <1208851058-8500-2-git-send-email-jens.axboe@oracle.com>	 <480DACDD.7040108@qumranet.com> <20080422092230.GW12774@kernel.dk>	 <20080422111403.GX12774@kernel.dk> <1208869254.7115.258.camel@twins>	 <20080422142543.GG12774@kernel.dk>  <480DF861.6000705@qumranet.com> <1208875437.7115.271.camel@twins>
In-Reply-To: <1208875437.7115.271.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>> Perhaps we need a new flag for failable async IPIs (or better, API).  
>> I'm pretty sure no one uses s_c_f_s() from irq disabled context on x86, 
>> since it will WARN_ON(irqs_disabled()).
>>     
>
> Yeah, no current users, but that doesn't say I don't want to add new
> ones ;-

I suggest having a new API for that, I dislike long tails of flag arguments.

smp_call_function_single_async()?

-- 
error compiling committee.c: too many arguments to function

