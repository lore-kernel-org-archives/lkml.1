Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbYF0SIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbYF0SIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763250AbYF0SIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:08:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4015 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763528AbYF0SIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:08:00 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5327"; a="4286406"
Message-ID: <48652C7F.1000904@qualcomm.com>
Date: Fri, 27 Jun 2008 11:07:59 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, jarkao2@o2.pl,
       linux-kernel@vger.kernel.org
Subject: Re: workqueue flush_work() patches
References: <486525FE.1060509@qualcomm.com> <20080627175633.GA842@tv-sign.ru>
In-Reply-To: <20080627175633.GA842@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 06/27, Max Krasnyansky wrote:
>> I'm not sure if you guys saw my last email on this. So I'll restart the 
>> thread.
>> If you guys are ok with the summary I provided below I can put all 
>> Oleg's patches into some git tree, test them on my boxes and resend to 
>> Andrew.
> 
> I'll re-send these flush_work() patches to Andrew on Sunday,
Excellent. Feel free to include
Acked-By: Max Krasnyansky <maxk@qualcomm.com>

>> I was also going to go over the users of flush_queued_work() and 
>> convert them to cancel_work_sync() and/or flush_work().
> 
> I think this would be very nice in any case.
> 
> but I don't think flush_work() will find a lot of users...
Well, you've already found one (schedule_on_each_cpu()) there will 
probably be more. But I agree that flush is mostly used in cleanup 
procedures and therefor most users just need cancel_work_sync().

Max
