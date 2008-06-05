Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYFEIX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYFEIX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYFEIXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:23:41 -0400
Received: from saeurebad.de ([85.214.36.134]:53391 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYFEIXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:23:39 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
References: <20080605115235.6453.E1E9C6FF@jp.fujitsu.com>
	<87abi0semc.fsf@saeurebad.de>
	<20080605134455.6457.E1E9C6FF@jp.fujitsu.com>
Date: Thu, 05 Jun 2008 10:22:52 +0200
In-Reply-To: <20080605134455.6457.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Thu, 05 Jun 2008 14:26:29 +0900")
Message-ID: <877id4jnoj.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> Hi.
>
>> >> 
>> >> Could you boot a working image with bootmem_debug in the command line?
>> >> Perhaps seeing the usual bootmem usage on this box gives a hint what is
>> >> broken.
>> >
>> > Ok. I'll try it.
>> 
>> Thanks!
>
> I attached bootmem log with related message. 
> If you realize anything, please let me know.
>
> Note: 
>   In this hardware configuration, node 1 to 16 are "memory less" node.
>   They may be hot-added later.
>   So, there are some messages of "no start_pfn".
>   But, for_each_loop of bootmem skips them because ia64 kernel checks
>   "memory less" node and skip to call init_bootmem_node().
>   I think it is not cause.

Thank you very much.  I think I spotted the bug and will provide an
explanation and a patch when I am awake again.

	Hannes
