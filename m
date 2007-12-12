Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbXLLTPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbXLLTPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXLLTP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:15:26 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:40077 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXLLTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:15:25 -0500
Message-ID: <47603332.8060605@codemonkey.ws>
Date: Wed, 12 Dec 2007 13:14:58 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: 7eggert@gmx.de, Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: relax signature check
References: <9yY38-5oa-11@gated-at.bofh.it>	<E1J27Or-00012X-DF@be1.7eggert.dyndns.org> <475EC5E5.80104@goop.org>
In-Reply-To: <475EC5E5.80104@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Bodo Eggert wrote:
>> Not BUG_ON(memcmp(xen_start_info->magic, "xen-3.", 6) != 0); ?
>> I don't thin Xen version 32 will be compatible ...
>>   
> 
> It had better be; if it loads the kernel, it should present a xen-3
> compatible ABI.

If xen-32.0 should be compatible than wouldn't xen-24.0 be compatible 
too?  I think the point was that you should either be checking for 
'xen-3.x' or something more general that would accept anything >= xen-3.0.

Regards,

Anthony Liguori

> But this is just a sanity check to make sure things are basically OK;
> BUG_ON is hardly nice error reporting (not that there's much else we can
> do at that point).
> 
>     J

