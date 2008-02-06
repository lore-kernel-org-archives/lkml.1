Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbYBFCTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbYBFCTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbYBFCTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:19:14 -0500
Received: from koto.vergenet.net ([210.128.90.7]:58547 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528AbYBFCTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:19:13 -0500
Date: Wed, 6 Feb 2008 11:19:09 +0900
From: Simon Horman <horms@verge.net.au>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Make wrr "no available servers" error message
	rate-limited
Message-ID: <20080206021909.GA32678@verge.net.au>
References: <1202243421-2774-1-git-send-email-sven.wegener@stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202243421-2774-1-git-send-email-sven.wegener@stealer.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 09:30:21PM +0100, Sven Wegener wrote:
> No available servers is more an error message than something informational. It
> should also be rate-limited, else we're going to flood our logs on a busy
> director, if all real servers are out of order with a weight of zero.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>

Hi Sven,

this looks good to me.

Acked-by: Simon Horman <horms@verge.net.au>

> ---
> 
> Actually, do we need this message at all? The wrr scheduler is the only one
> printing an error message in such a case.

I was wondering about that too. Though I'd err on the side of adding
it to the other schedulers as neccessary rather than removing it here.
But if you'd rather just get rid of it, I have no strong objections.

-- 
Horms

