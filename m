Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbZCPJ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbZCPJ4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbZCPJpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:45:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:49283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664AbZCPJpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:45:38 -0400
Message-ID: <49BE1FB8.6000505@kernel.org>
Date: Mon, 16 Mar 2009 18:45:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] block: clean up request completion API
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <1236920578-2179-10-git-send-email-tj@kernel.org> <49BE180A.7010904@panasas.com>
In-Reply-To: <49BE180A.7010904@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 09:45:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> I have a small request below, if it's OK?

Sure.

> 
> + *     Drivers that supports bidi can safely call this member for any type
> + *     of request, bidi or uni. In the later case @bidi_bytes is just
> + *     ignored.
> 
> Please add some comment like above, the subject arose a few times before
> where programmers thought they need to do an if() and call this or above
> blk_end_request.

Comment added as suggested and patch description updated accordingly.
Git tree has been rebased.  New commit ID is
5b437c316dcdb30598a73b03f529df89e880ac15.

Thanks.

-- 
tejun
