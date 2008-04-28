Return-Path: <linux-kernel-owner+w=401wt.eu-S966081AbYD1VEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966081AbYD1VEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbYD1VEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:04:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013AbYD1VEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:04:14 -0400
Message-ID: <48163B84.90605@zytor.com>
Date: Mon, 28 Apr 2008 14:03:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu>
In-Reply-To: <20080428202552.GG15840@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Mathieu Desnoyers wrote:
>>> Thanks to Peter for the review.
>> Just in case someone gets the wrong idea...
>>
>> I still think this is the completely wrong approach.
> 
> hm, can it result in a broken kernel? If yes, how? Or are your 
> objections more higher level?
> 

My objections are higher level, I believe the current code is (a) 
painfully complex, and I'd rather not see it in the kernel, and (b) the 
wrong thing anyway.

Put a 5-byte nop in as the marker, and patch it with a call instruction, 
out of line, to a collector function.

	-hpa
