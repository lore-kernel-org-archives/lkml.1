Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZC3RUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZC3RUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZC3RUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:20:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:51529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZC3RUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:20:34 -0400
Message-ID: <49D0FF56.3080205@kernel.org>
Date: Tue, 31 Mar 2009 02:20:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org> <49D0A985.7090307@panasas.com>
In-Reply-To: <49D0A985.7090307@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 30 Mar 2009 17:20:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
>> P.S.: Boaz, the above patchset implements blk_rq_map_kern_sgl() 
> 
> What is blk_rq_map_kern_sgl() ? I'm not sure I remember ?
> What is it's API? and what does it do?
> 
>> and kills the SCSI layer hack.  That was the issue you were trying
>> to solve, right?
> 
> If you post URL of git tree I can have a look and start an early review
> if you want

Here's the patchset.  It builds but I haven't even booted it yet, so
expect some breakages.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=map-untested
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git map-untested

Thanks.

-- 
tejun
