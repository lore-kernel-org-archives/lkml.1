Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXJ2NPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXJ2NPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXJ2NPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:15:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27243 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbXJ2NPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:15:24 -0400
Date: Mon, 29 Oct 2007 14:13:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cleanup asm/scatterlist.h includes
Message-ID: <20071029131301.GD5001@kernel.dk>
References: <20071029124907.GI7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029124907.GI7227@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2007, Adrian Bunk wrote:
> Not architecture specific code should not #include <asm/scatterlist.h>.
> 
> This patch therefore either replaces them with
> #include <linux/scatterlist.h> or simply removes them if they were 
> unused.

Looks fine to me - what did you compile test this on?

-- 
Jens Axboe

