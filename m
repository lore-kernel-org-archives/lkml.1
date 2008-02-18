Return-Path: <linux-kernel-owner+w=401wt.eu-S1761138AbYBRUUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138AbYBRUUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYBRUT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:19:57 -0500
Received: from ns1.suse.de ([195.135.220.2]:37834 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYBRUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:19:56 -0500
From: Andreas Schwab <schwab@suse.de>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       petkovbb@gmail.com, j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de>
	<58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
	<20080218.135827.74754725.k-ueda@ct.jp.nec.com>
X-Yow: I'm not available for comment..
Date: Mon, 18 Feb 2008 21:19:53 +0100
In-Reply-To: <20080218.135827.74754725.k-ueda@ct.jp.nec.com> (Kiyoshi Ueda's
	message of "Mon\, 18 Feb 2008 13\:58\:27 -0500 \(EST\)")
Message-ID: <jey79if252.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:

> Could you try this patch?
> I've only done a compile test, so this patch may not work.
>
> During the conversion to blk_end_request, the code was changed
> *not* to set rq->data_len = 0.
> I removed that part because I thought it was just a trigger to
> call post_transform_command().  However, since data_len can be
> used as a residual length of the transfer, it might have to remain
> there.
> Actually, wodim seems checking the residual count how far it wrote
> (e.g. wodim/wodim.c:write_track_data()).
>
> This patch brings back the rq->data_len = 0.

Looks good, I was successfully able to burn a CD-RW.

Thanks, Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
