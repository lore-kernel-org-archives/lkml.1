Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZCNQLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZCNQLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZCNQLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:11:05 -0400
Received: from gw.goop.org ([64.81.55.164]:58700 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZCNQLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:11:03 -0400
Message-ID: <49BBD715.9050009@goop.org>
Date: Sat, 14 Mar 2009 09:11:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: tip.git regression from "vsprintf: unify the format decoding
 layer for its 3 users"
References: <20090314110850.GA5174@damson.getinternet.no>
In-Reply-To: <20090314110850.GA5174@damson.getinternet.no>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 2009/3/14 Jeremy Fitzhardinge <jeremy@goop.org>:
>   
>> Change fef20d9c1380f04ba9492d6463148db07b413708, "vsprintf: unify the format
>> decoding layer for its 3 users", causes a regression in xenbus which results
>> in no devices getting attached to a new domain.  Reverting
>> fef20d9c1380f04ba9492d6463148db07b413708 and
>> 39e874f8afbdb3745e2406ce4ecbde9ac4cbaa78 fixes the problem.
>>
>> I haven't identified what format string is being handled wrongly, so I don't
>> know what the precise bug is.  The most complex looking format in use seems
>> to be %.*s; there's also "%s/%s", "%i" and "%lX".
>>     
>
> Hi,
>
> At least %.*s seems to be broken. How about this patch?
>   

Thanks, that does the trick.

    J
