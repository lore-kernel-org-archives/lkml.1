Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYL2ObG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYL2ObG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYL2Oaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:30:55 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:1369 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYL2Oay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:30:54 -0500
Message-ID: <4958DF1C.7010002@cybernetics.com>
Date: Mon, 29 Dec 2008 09:30:52 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Subject: Re: DEBUG_PAGEALLOC + order-10 alloc/free_pages = lockup
References: <49513E33.5050001@cybernetics.com> <20081226094857.GP27747@elte.hu> <4954AA0B.9030401@linux.intel.com>
In-Reply-To: <4954AA0B.9030401@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> I also wonder who is doing an order 10 allocation... that'd worry me ;)
>
>   

I was waiting for someone to ask that.  This is for an embedded device
that spends most of its time doing DMA.  Almost all of main memory is
allocated as an I/O buffer right after booting.  I don't actually need
high-order allocations, but since Linux supports it, I use it to reduce
the number of scatter/gather entries and associated overhead.  Works
great most of the time, except when I hit this bug.

Tony
