Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZEJX3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZEJX3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZEJX3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:29:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbZEJX3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:29:34 -0400
Message-ID: <4A0763A5.4050600@kernel.org>
Date: Mon, 11 May 2009 08:30:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Borislav Petkov <petkovbb@googlemail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH 0/12] ide-atapi remove pc->buf
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <200905102332.24775.bzolnier@gmail.com>
In-Reply-To: <200905102332.24775.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 10 May 2009 23:29:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bartlomiej.

Bartlomiej Zolnierkiewicz wrote:
> Good question, how's about:
> 
> Once tj/block-unify-sector-and-data_len is in block/for-2.6.31 and your tree
> is ready I will pull it into the separate branch.  This branch can be then
> pulled into ide/for-next or into new ide/all branch (replacing ide/for-next
> in linux-next).
> 
> This means that I'll have to synchronize merge window merges with Jens but
> this is needed already and shouldn't be a problem.
> 
> If somebody [ Tejun/Jens: I'm talking to you :) ] has a better idea how to
> handle this please stand-up.

There needs to be a sync point anyway and there's one more patchset on
top of block-unify-sector-and-data_len involving ide changes (the
block-peek-fetch one), so if both get acked by Jens, it would be
easier to simply branch out from there.  From there on, I don't expect
too much disruption to ide from further block layer changes, so things
should be okay.

Thanks.

-- 
tejun
