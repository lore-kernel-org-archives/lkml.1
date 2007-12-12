Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbXLLRyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbXLLRyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXLLRyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:54:23 -0500
Received: from brick.kernel.dk ([87.55.233.238]:25700 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbXLLRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:54:22 -0500
Date: Wed, 12 Dec 2007 18:54:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let elv_register() return void
Message-ID: <20071212175417.GC18857@kernel.dk>
References: <20071212174711.GC10069@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212174711.GC10069@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12 2007, Adrian Bunk wrote:
> elv_register() always returns 0, and there isn't anything it does where 
> it should return an error (the only error condition is so grave that 
> it's handled with a BUG_ON).

Principally it could return -EEXIST for the BUG_ON(), but there's little
point. I've applied your patch, thanks.

-- 
Jens Axboe

