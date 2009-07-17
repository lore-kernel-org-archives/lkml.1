Return-Path: <linux-kernel-owner+w=401wt.eu-S933628AbZGQFwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbZGQFwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933476AbZGQFwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:52:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:45367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbZGQFwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:52:11 -0400
Message-ID: <4A601145.8090605@kernel.org>
Date: Fri, 17 Jul 2009 14:51:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH #tj-block-for-linus] block: fix failfast merge testing
 in elv_rq_merge_ok()
References: <4A5ECC62.7050607@kernel.org> <4A5EDD81.6060409@panasas.com> <4A5EDF90.7090900@kernel.org> <4A5EE2BD.8030100@panasas.com> <4A5EE63F.9050205@kernel.org> <4A5EE977.5070400@panasas.com>
In-Reply-To: <4A5EE977.5070400@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Jul 2009 05:51:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 07/16/2009 11:35 AM, Tejun Heo wrote:
>> Boaz Harrosh wrote:
>>> OK So could you put a FIXME: and fat comment, on that weird "!"(s)
>>> everywhere?
>> Yeap, sure.  How about something like the following?
>>
>> 	/*
>> 	 * Don't merge if failfast settings don't match.  The negation
> 
> - 	 * Don't merge if failfast settings don't match.  The negation
> + 	 * Don't merge if failfast settings don't match.
> +	 * FIXME:   The negation ...

So updated.  Thanks.

-- 
tejun
