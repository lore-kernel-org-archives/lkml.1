Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbZJEGrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbZJEGrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZJEGrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:47:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58494 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZJEGrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:47:35 -0400
Date: Mon, 5 Oct 2009 08:46:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: cfq: fix possible problem with jiffies wraparound
Message-ID: <20091005064657.GP26573@kernel.dk>
References: <200910041909.08282.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910041909.08282.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04 2009, Corrado Zoccolo wrote:
> The RR service tree is indexed by a key that is relative to current jiffies.
> This can cause problems on jiffies wraparound.
> 
> The patch fixes it using time_before comparison, and changing
> the add_front path to use a relative number, too.

Good spotting, applied.

-- 
Jens Axboe

