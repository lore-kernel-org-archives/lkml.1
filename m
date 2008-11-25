Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYKYIGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYKYIGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKYIGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:06:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60862 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYKYIGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:06:38 -0500
Date: Tue, 25 Nov 2008 09:04:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] don't take lock on changing ra_pages
Message-ID: <20081125080438.GQ26308@kernel.dk>
References: <20081123101907.GA12218@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123101907.GA12218@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23 2008, Wu Fengguang wrote:
> There's no need to take queue_lock or kernel_lock when modifying
> bdi->ra_pages. So remove them. Also remove out of date comment for
> queue_max_sectors_store().

Thanks, applied to for-2.6.29.

-- 
Jens Axboe

