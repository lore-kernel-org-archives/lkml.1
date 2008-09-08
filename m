Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYIHJsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYIHJsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYIHJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:48:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57582 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750902AbYIHJsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:48:45 -0400
Message-ID: <48C4F4F8.20105@sgi.com>
Date: Mon, 08 Sep 2008 11:48:40 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for	smp_call_function_mask
References: <20080905214019.821172000@polaris-admin.engr.sgi.com> <20080906132944.GC4910@elte.hu>
In-Reply-To: <20080906132944.GC4910@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Applies to linux-2.6.tip/master (with FUZZ).
> 
> applied to tip/cpus4096, thanks Mike.
> 
> I'm still wondering whether we should get rid of non-reference based 
> cpumask_t altogether ...

Cool,

I think we should, it's like a ticking bomb waiting to explode on us
eventually. IMHO it was a big mistake to allow cpumask_t being passed
by value in the first place.

Cheers,
Jes
