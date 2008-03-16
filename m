Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYCPXBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYCPXBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYCPXB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:01:26 -0400
Received: from gw.goop.org ([64.81.55.164]:54812 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYCPXBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:01:25 -0400
Message-ID: <47DDA624.8000307@goop.org>
Date: Sun, 16 Mar 2008 15:58:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH 1/7] x86-64: introduce fast variant of smp_call_function_single()
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com> <1205322940-20127-2-git-send-email-jens.axboe@oracle.com> <47DAC21C.1040805@goop.org> <20080316184506.GW17940@kernel.dk>
In-Reply-To: <20080316184506.GW17940@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Mar 14 2008, Jeremy Fitzhardinge wrote:
>   
>> Jens Axboe wrote:
>>     
>>> rom: Nick Piggin <npiggin@suse.de>
>>>  
>>>       
>> Why is this necessary?  How is smp_call_function_single slow?
>>     
>
> Because it's completely serialized by the call_lock spinlock.
>   

Hm, yes.  Would it be possible to implement smp_call_function_mask in a 
generic way to avoid that?  Turn the static structure into a per-cpu 
request list?

    J
