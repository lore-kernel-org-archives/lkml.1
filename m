Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYKPQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYKPQNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYKPQNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:13:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:49655 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYKPQNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:13:45 -0500
Message-ID: <ac3eb2510811160813j5965a92cj1f4ad6979ecd7090@mail.gmail.com>
Date: Sun, 16 Nov 2008 17:13:42 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] depmod: sort output according to modules.order, take #2
Cc: "Jon Masters" <jonathan@jonmasters.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, notting@redhat.com,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <491FAEB8.5010501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475936CE.70703@gmail.com> <475BB5AE.40503@gmail.com>
	 <477B71F0.8020706@gmail.com>
	 <200801031012.22776.rusty@rustcorp.com.au>
	 <1199318319.2044.22.camel@perihelion> <491C1158.8090901@gmail.com>
	 <1226776813.4894.1.camel@jcmlaptop> <491FAEB8.5010501@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 06:25, Tejun Heo <htejun@gmail.com> wrote:
> Jon Masters wrote:
>> On Thu, 2008-11-13 at 20:36 +0900, Tejun Heo wrote:
>>
>>> Jon, this patch hasn't made into module-init-tools
>>
>> I'm redoing it to cope with the binary sorted output files we have now -
>> i.e. we can't just rely upon the order of modules.dep any more, what
>> you're actually trying to do with modules.order is ensure that e.g.
>> modules providing conflicting aliases get handled in "order".
>
> Yes, that's right.  Ah... so, now modules.dep is sorted to speed up
> module look up?

It's a match tree, stored in a binary file format, not a specific ordering.

> Is this code already in module-init-tools?

http://git.kernel.org/?p=utils/kernel/module-init-tools/module-init-tools.git;a=summary

Kay
