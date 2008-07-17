Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYGQPDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYGQPDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbYGQPC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:02:58 -0400
Received: from gw.goop.org ([64.81.55.164]:58920 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbYGQPC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:02:57 -0400
Message-ID: <487F5F15.4050208@goop.org>
Date: Thu, 17 Jul 2008 08:02:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: Large increase in context switch rate
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins>
In-Reply-To: <1216286250.5232.67.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Is this specific to Xen?, as a native kernel doesn't do more than ~3k
> cs/s with make -j3 on my dual core.
>   

No, it doesn't seem to be.  A CONFIG_PARAVIRT kernel running on bare 
hardware shows the same context switch rate.  Merely turning 
CONFIG_PARAVIRT on should have no effect on context switch rate (though, 
Alex, it would be worth double-checking, just to be sure).

    J
