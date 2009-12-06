Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbZLFKtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbZLFKtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbZLFKtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:49:45 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45292 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626AbZLFKtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:49:45 -0500
Date: Sun, 6 Dec 2009 11:49:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was
	delayed
Message-ID: <20091206104950.GN8742@kernel.dk>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com> <4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com> <4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06 2009, Corrado Zoccolo wrote:
> Hi Jeff,
> I remember you saw large performance drop on your SAN for sequential
> writes with low_latency=1.  Can you test if Shaohua's and this patch
> fix allow to recover some bandwidth?  I think that enabling the queue
> depth ramp up only if a sync request was delayed should disable it for
> fast hardware like yours, so you should not be seeing the slowdown any
> more.

I queued this up for post inclusion into 2.6.33, with the time_after()
fixed.

The patch was word-wrapped, btw.

-- 
Jens Axboe

