Return-Path: <linux-kernel-owner+w=401wt.eu-S933684AbYA3UUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbYA3UUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765824AbYA3UQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:16:00 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9054 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbYA3UP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:15:58 -0500
Date: Wed, 30 Jan 2008 21:15:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] block/sunvdc.c:print_version() must be __devinit
Message-ID: <20080130201553.GZ15220@kernel.dk>
References: <20080130200327.GK29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130200327.GK29368@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30 2008, Adrian Bunk wrote:
> This patch fixes the following section mismatches:
> 
> <--  snip  -->
> 
> ...
> WARNING: drivers/block/sunvdc.o(.text+0xf0): Section mismatch in reference from the function print_version() to the variable .devinit.data:version
> WARNING: drivers/block/sunvdc.o(.text+0xf8): Section mismatch in reference from the function print_version() to the variable .devinit.data:version
> ...
> 
> <--  snip  -->

applied

-- 
Jens Axboe

