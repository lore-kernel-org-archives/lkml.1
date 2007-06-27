Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbXF0Qoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbXF0Qoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXF0Qog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:44:36 -0400
Received: from mail.tmr.com ([64.65.253.246]:43530 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXF0Qof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:44:35 -0400
Message-ID: <46829432.4050302@tmr.com>
Date: Wed, 27 Jun 2007 12:45:38 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
       akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
Subject: Re: [md-accel PATCH 00/19] md raid acceleration and the async_tx
 api
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> Greetings,
>
> Per Andrew's suggestion this is the md raid5 acceleration patch set
> updated with more thorough changelogs to lower the barrier to entry for
> reviewers.  To get started with the code I would suggest the following
> order:
> [md-accel PATCH 01/19] dmaengine: refactor dmaengine around dma_async_tx_descriptor
> [md-accel PATCH 04/19] async_tx: add the async_tx api
> [md-accel PATCH 07/19] md: raid5_run_ops - run stripe operations outside sh->lock
> [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
>
> The patch set can be broken down into three main categories:
> 1/ API (async_tx: patches 1 - 4)
> 2/ implementation (md changes: patches 5 - 15)
> 3/ driver (iop-adma: patches 16 - 19)
>
> I have worked with Neil to get approval of the category 2 changes.
> However for the category 1 and 3 changes there was no obvious
> merge-path/maintainer to work through.  I have thus far extrapolated
> Neil's comments about 2 out to 1 and 3, Jeff gave some direction on a
> early revision about the scalability of the API, and the patch set has
> picked up various fixes and suggestions from being in -mm for a few
> releases.  Please help me ensure that this code is ready for Linus to
> pull for 2.6.23.
>
> 	git://lost.foo-projects.org/~dwillia2/git/iop md-accel-linus
>   

Dan, I hope you will release these as a patchset against 2.6.22 when 
it's out or 2.6.21. I find I have a lot more confidence in results, good 
or bad, when comparing something I have run in production with just one 
patchset added. There are enough other changes in an -rc to confuse the 
issue, and I don't run them in production (at least not usually).

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

