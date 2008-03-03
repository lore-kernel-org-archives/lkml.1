Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbYCCEUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbYCCEUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYCCETz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:19:55 -0500
Received: from verein.lst.de ([213.95.11.210]:60245 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbYCCETy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:19:54 -0500
Date: Mon, 3 Mar 2008 05:19:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jens Axboe <axboe@kernel.dk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3disk: Remove a superfluous cast
Message-ID: <20080303041916.GB22960@lst.de>
References: <Pine.LNX.4.64.0802151440090.21784@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802151440090.21784@vixen.sonytel.be>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 02:42:03PM +0100, Geert Uytterhoeven wrote:
> ps3disk: Remove a superfluous cast
> 
> As ps3disk is a ppc64-only driver, sector_t equals to unsigned long, and the
> cast is not needed.
> 
> Reuse in another (possibly 32-bit) driver is protected by the safety net called
> `compiler warning' (with the cast, it may silently truncate to 32-bit).
> If sector_t ever changes, we will get a compiler warning as well (with the
> cast, we won't).

Yes, this sounds fine to me.

ACK.

