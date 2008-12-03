Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYLCQoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYLCQoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYLCQof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:44:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:60761 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYLCQof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:44:35 -0500
Cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wolfgang Grandegger <wg@grandegger.com>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>,
       linux-ppc list <linuxppc-dev@ozlabs.org>, linux-mtd@lists.infradead.org
Message-Id: <965E56B6-4317-448E-9541-9CB1615E623B@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: avorontsov@ru.mvista.com
In-Reply-To: <20081203162723.GA32301@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH for 2.6.28] NAND: fsl_upm: fix build problem with 2.6.28-rc2
Date: Wed, 3 Dec 2008 10:43:12 -0600
References: <20081126163840.GA21669@oksana.dev.rtsoft.ru> <4A183575-1142-4EC2-83C4-145E721E6E8D@kernel.crashing.org> <20081203162723.GA32301@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 3, 2008, at 10:27 AM, Anton Vorontsov wrote:

> On Wed, Dec 03, 2008 at 09:47:53AM -0600, Kumar Gala wrote:
> [...]
>>> The patch fixes following build error:
>>>
>>> CC      drivers/mtd/nand/fsl_upm.o
>>> drivers/mtd/nand/fsl_upm.c: In function 'fun_chip_init':
>>> drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 2 of
>>> 'of_mtd_parse_partitions' from incompatible pointer type
>>> drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 3 of
>>> 'of_mtd_parse_partitions' from incompatible pointer type
>>> drivers/mtd/nand/fsl_upm.c:168: error: too many arguments to  
>>> function
>>> 'of_mtd_parse_partitions'
>>> make[1]: *** [drivers/mtd/nand/fsl_upm.o] Error 1
>>>
>>> The breakage was introduced in
>>> 69fd3a8d098faf41a04930afa83757c0555ee360
>>> ("[MTD] remove unused mtd parameter in of_mtd_parse_partitions()").
>>>
>>> While at it, also add a check for the of_mtd_parse_partitions()  
>>> return
>>> value.
>>>
>>> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
>>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> [...]
>> David,
>>
>> what's going on with this patch?
>
> Recently I got email from Andrew's patch tracking system that
> the patch was merged into subsystem tree. Here it is:
>
> http://git.infradead.org/mtd-2.6.git?a=commitdiff;h=29b65861fbece04cfdf3fee352d5247369131850

is it going into 2.6.28 or waiting for .29?

- k
