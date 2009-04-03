Return-Path: <linux-kernel-owner+w=401wt.eu-S936037AbZDCSDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936037AbZDCSDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933787AbZDCSDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:03:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49004 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603AbZDCSDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:03:19 -0400
Date: Fri, 3 Apr 2009 20:03:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH] ps3vram: Replace mutex by spinlock + list
Message-ID: <20090403180317.GB5178@kernel.dk>
References: <1238763938-7076-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1238763938-7076-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1238763938-7076-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1238763938-7076-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238763938-7076-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03 2009, Geert Uytterhoeven wrote:
> Remove the mutex serializing access to the cache.
> Instead, queue up new requests on a list if the driver is busy.
> 
> This improves sequential write performance by ca. 2%.

Great, precisely the method I wanted to see there! I've added your three
patches, thanks Geert.


-- 
Jens Axboe

