Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXISROI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXISROI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXISRN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:13:56 -0400
Received: from mail.suse.de ([195.135.220.2]:38484 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbXISRNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:13:55 -0400
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A little coding style nugget of joy
References: <20070919123401.9369534d.kernel1@cyberdogtech.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 19:13:54 +0200
In-Reply-To: <20070919123401.9369534d.kernel1@cyberdogtech.com>
Message-ID: <p73odfyvar1.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt LaPlante <kernel1@cyberdogtech.com> writes:

> Since everyone loves random statistics, here are a few gems to give you a break from your busy day:
> 
> Number of lines in the 2.6.22 Linux kernel source that include one or more trailing whitespaces: 135209
> Bytes saved by removing said whitespace: 151809

You don't actually save anything on disk on most file systems
(essentially everything except reiserfs on current Linux)
because all files are rounded to block size (normally 4K) 

Same in page cache.

And in tar files bzip2/gzip is very good at compacting them.

> Lines in the (unified) diff: 455437
> Size of the diff: 15M
> People brave enough to submit the patch: ~0

Many kernel maintainers automatically remove trailing white space on any new 
lines these days. So as the kernel keeps changing it should eventually all
disappear; except on essentially dead code.

-Andi
