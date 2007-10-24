Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXJXG6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXJXG6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXJXG6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:58:42 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17349 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbXJXG6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:58:41 -0400
Date: Wed, 24 Oct 2007 08:58:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Helge Deller <deller@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/core/message.c: scatterlist include fix
Message-ID: <20071024065838.GY14671@kernel.dk>
References: <200710232137.55661.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710232137.55661.deller@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Helge Deller wrote:
> This fixes following bug when building for parisc-linux:
> 
> drivers/usb/core/message.c: In function `usb_sg_init':
> drivers/usb/core/message.c:440: error: implicit declaration of function `sg_virt'

This already got fixed by commit
117636092a87a28a013a4acb5de5492645ed620f from Ralf.

-- 
Jens Axboe

