Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZEPWHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZEPWHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZEPWHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:07:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:49976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZEPWHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:07:20 -0400
Message-ID: <4A0F3963.8050000@kernel.org>
Date: Sun, 17 May 2009 07:08:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Borislav Petkov <petkovbb@googlemail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/15 v2] ide-atapi: remove pc->buf and misc cleanups
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com> <200905162107.38332.bzolnier@gmail.com>
In-Reply-To: <200905162107.38332.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 16 May 2009 22:07:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
>> It also got rebased ontop of block/for-2.6.31 after Tejun's stuff got merged.
...
> Looking at creation dates I suspect that somewhere along the way
> something was rebased?
> 
> One quick temporary solution would be to recreate bp/pc-remove-buf
> on top of tj/block-peek-fetch...

Oh.. please use block commit.  Jens didn't pull in my tree but applied
patches on top of the block tree, so my commits shouldn't be in any
official trees.

Thanks.

-- 
tejun
