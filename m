Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbYCAJzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbYCAJzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYCAJzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 04:55:24 -0500
Received: from brick.kernel.dk ([87.55.233.238]:26103 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbYCAJzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 04:55:23 -0500
Date: Sat, 1 Mar 2008 10:55:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 00/24] ide-tape: remove pipelined mode operation
Message-ID: <20080301095518.GW6704@kernel.dk>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's the 1st draft of the pipeline removal series. As the diffstat below openly
> states it, a lot of code got removed - even more than the cleanup series we did
> earlier. There are several issues that we need to address concerning these
> patches:
> 
> 1. only compile-tested since i don't have the hardware, i.e. longer -mm brewing is
> advisable the least.
> 
> 2. I have left the tape->merge_stage buffer structure along with its
> alloc/free functions intact for now, for simplicity. The next step would be
> to go and carefully audit the code and then remove that last piece
> too and use allocations on the stack instead. I guess we still expect
> Jens's response on whether blk_{get,put}_request is the way to go here.
> 
> Jens?

Hm, I have not seen any questions regarding this directed my way :-)
Please point me to the original question and I'll take a look at it.

-- 
Jens Axboe

