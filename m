Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZGPItA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZGPItA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZGPItA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:49:00 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:2737
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753049AbZGPIs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:48:59 -0400
Message-ID: <4A5EE977.5070400@panasas.com>
Date: Thu, 16 Jul 2009 11:48:55 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH #tj-block-for-linus] block: fix failfast merge testing
 in elv_rq_merge_ok()
References: <4A5ECC62.7050607@kernel.org> <4A5EDD81.6060409@panasas.com> <4A5EDF90.7090900@kernel.org> <4A5EE2BD.8030100@panasas.com> <4A5EE63F.9050205@kernel.org>
In-Reply-To: <4A5EE63F.9050205@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 08:48:57.0536 (UTC) FILETIME=[41A9EC00:01CA05F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2009 11:35 AM, Tejun Heo wrote:
> Boaz Harrosh wrote:
>> OK So could you put a FIXME: and fat comment, on that weird "!"(s)
>> everywhere?
> 
> Yeap, sure.  How about something like the following?
> 
> 	/*
> 	 * Don't merge if failfast settings don't match.  The negation

- 	 * Don't merge if failfast settings don't match.  The negation
+ 	 * Don't merge if failfast settings don't match.
+	 * FIXME:   The negation ...

> 	 * in front of each condition is necessary because bio and
> 	 * request flags use different bit positions and the accessors
> 	 * return those bits directly.  This ugliness will soon go
> 	 * away.
> 	 */
> 

Boaz
