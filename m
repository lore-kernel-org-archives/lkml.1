Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXB0Uml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXB0Uml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXB0Uml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:42:41 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40253 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbXB0Umk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:42:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, zwane@infradead.org, ashok.raj@intel.com,
       mingo@elte.hu, yinghai.lu@amd.com, protasnb@gmail.com, ak@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 14/14] genirq: Mask irqs when migrating them.
References: <m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hctdt7ub.fsf_-_@ebiederm.dsl.xmission.com>
	<20070223180655.B2120@unix-os.sc.intel.com>
	<20070227122657.a8c9d2c0.akpm@linux-foundation.org>
Date: Tue, 27 Feb 2007 13:41:27 -0700
In-Reply-To: <20070227122657.a8c9d2c0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 27 Feb 2007 12:26:57 -0800")
Message-ID: <m13b4rl4eg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>>
>
> arghg.  Please don't top-post.  Ever.  At all.  Don't even think about 
> thinking about it.
>
> <edit, edit>
>
>> Andrew, This is a bug fix and must go in before 2.6.21.
>> 
>> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
> OK.  But the rest of the patch series was a bit of a trainwreck against
> Andi's pending tree so I ducked it all.
>
> If it's really needed for 2.6.21 then we have some work to do.  Presumably
> carefully reviewing and testing this new work then repairing Andi's tree. 

I guess I should take a look at Andi's tree and see what I have wrecked.
Linus has merged the changes.

For myself the careful review and testing is why it took me so long to
generate the darn thing.

I will be happy to take all of 3rd part review I can get though.

Eric
