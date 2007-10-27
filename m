Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbXJ0Les@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbXJ0Les (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 07:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXJ0Lek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 07:34:40 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21689 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbXJ0Lek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 07:34:40 -0400
Date: Sat, 27 Oct 2007 13:34:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] compat_ioctl: fix block device compat ioctl regression
Message-ID: <20071027113435.GG8875@kernel.dk>
References: <47221F91.60401@overt.org> <200710270051.38748.arnd@arndb.de> <47228A9E.80505@overt.org> <200710271138.06456.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710271138.06456.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27 2007, Arnd Bergmann wrote:
> From: Philip Langdale <philipl@overt.org>
> The conversion of handlers to compat_blkdev_ioctl accidentally
> disabled handling of most ioctl numbers on block devices because
> of a typo. Fix the one line to enable it all again.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> Mea Culpa. This should have been found by my testing, as it's clear
> that most of my big patch never worked at all. Sorry for causing
> problems for everyone involved here.
> 
> I'm attributing the patch to Philip, as he's the one who pointed
> out to me what the fix is.

Oops, added for swift inclusion.

-- 
Jens Axboe

