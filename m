Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYAORxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYAORxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYAORxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:53:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:43325 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYAORxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:53:41 -0500
Message-ID: <478CF31A.8040305@ct.jp.nec.com>
Date: Tue, 15 Jan 2008 09:53:30 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: move warning message of polling idle and HT	enabled
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <478C1475.7060706@ct.jp.nec.com> <20080115132607.GE7025@elte.hu>
In-Reply-To: <20080115132607.GE7025@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> Subject: [PATCH] x86: move warning message of polling idle and HT enabled
>>
>> This warning at idle_setup() is never shown because smp_num_sibling hasn't
>> been updated at this point yet.
>>
>> Move this polling idle and HT enabled warning message to 
>> select_idle_routine(). I also implement this warning on 64-bit kernel 
>> and make select_idle_routine() call after detect_ht() call.
> 
> looks good to me, but could you please split this up into two patches 
> instead - one that just moves/adds the printks, the other one that moves 
> the select_idle_routine() call? (Moving init calls around is notoriously 
> error-prone, so we want as small of a bisection target as possible.) 

Sure, I'll repost take3 soon.

Thanks,
Hiroshi Shimamoto

