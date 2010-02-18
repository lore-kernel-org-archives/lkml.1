Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab0BRCvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:51:54 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:38853 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab0BRCvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:51:51 -0500
Date: Wed, 17 Feb 2010 21:51:58 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Hung task - sync - 2.6.33-rc7  w/md6 multicore rebuild in	process
In-reply-to: <20100218023934.GC8897@atrey.karlin.mff.cuni.cz>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4B7CAB4E.2090002@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B76D87E.3050107@majjas.com> <4B76EC83.5050401@majjas.com>
 <20100218023934.GC8897@atrey.karlin.mff.cuni.cz>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/2010 9:39 PM, Jan Kara wrote:
>> On 2/13/2010 11:51 AM, Michael Breuer wrote:
>>      
>> Note: this cleared after about 90 minutes - sync eventually completed.
>> I'm thinking that with multicore enabled the resync is able to starve
>> out normal system activities that weren't starved w/o multicore.
>>      
>    Hmm, it is a bug in writeback code. But as Linus pointed out, it's not really
> clear why it's *so* slow. So when it happens again, could you please sample for
> a while (like every second for 30 seconds) stacks of blocked tasks via
> Alt-Sysrq-W? I'd like to see where flusher threads are hanging... Thanks.
>
> 								Honza
>    
Ok - will do. On rc8 now - and up about 3 days without any issues. If I 
have some time tomorrow I'll force a raid resync and see what happens.
