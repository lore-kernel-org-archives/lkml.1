Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXHGHRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXHGHRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXHGHRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:17:35 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17657 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbXHGHRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:17:34 -0400
Date: Tue, 7 Aug 2007 08:46:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: block/cfq-iosched.c - control reaches end of non-void function warning
Message-ID: <20070807064640.GP5245@kernel.dk>
References: <46B78758.8090101@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B78758.8090101@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06 2007, Gabriel C wrote:
> Hi Jens,
> 
> I just noticed this warning in one of my build logs :
> 
> ...
> 
> block/cfq-iosched.c: In function 'cfq_async_queue_prio':
> block/cfq-iosched.c:1430: warning: control reaches end of non-void function
> 
> ...
> 
> Guessing return 0; is missing there.

The default: case ends up in a BUG(), which does not return.

-- 
Jens Axboe

