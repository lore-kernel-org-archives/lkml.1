Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXEKM4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXEKM4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXEKM4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:56:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2210 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755384AbXEKM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:56:09 -0400
Message-ID: <4644A01F.4080501@ru.mvista.com>
Date: Fri, 11 May 2007 16:55:59 +0000
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Performance Stats: Kernel patch
References: <20070510171947.19532.70784.stgit@localhost.localdomain> <p731whofe73.fsf@bingen.suse.de>
In-Reply-To: <p731whofe73.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>Maxim Uvarov <muvarov@ru.mvista.com> writes:
>  
>
>>This data is useful for detecting hyperactivity
>>patterns between processes.
>>    
>>
>
>You need a lot better rationale to slow down these important
>fast paths. Particularly the syscall path is very hot.
>
>Is this something that is really generally useful? The context
>switch counters might be occasionally useful, but strace can
>you just give the syscall count anyways. Still not sure 
>it really should go into the standard kernel. Perhaps just keep it 
>as a systemtap script?
>
>-Andi
>  
>
It is difficult to use strace for multi thread applications to
verify which thread is doing what.
