Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXLIBwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXLIBwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 20:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXLIBwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 20:52:07 -0500
Received: from THUNK.ORG ([69.25.196.29]:37964 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbXLIBwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 20:52:05 -0500
Date: Sat, 8 Dec 2007 20:51:54 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] random: improve variable naming, clear extract
	buffer
Message-ID: <20071209015154.GW17037@thunk.org>
Mail-Followup-To: tytso@mit.edu, Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <7.753618428@selenic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7.753618428@selenic.com>
1;1609;0cFrom: Theodore Tso <tytso@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: Theodore Tso <tytso@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 05:21:00PM -0600, Matt Mackall wrote:
> random: improve variable naming, clear extract buffer
> 
> - split the SHA variables apart into hash and workspace
> - rename data to extract
> - wipe extract and workspace after hashing
> 
> diff -r 924f9a441236 drivers/char/random.c
> --- a/drivers/char/random.c	Sat Dec 08 16:22:29 2007 -0600
> +++ b/drivers/char/random.c	Sat Dec 08 16:32:31 2007 -0600
> @@ -461,7 +461,7 @@ static void __add_entropy_words(struct e
>  	unsigned long flags;
>  	/* rotate the add pointer more rapidly to span more of the
>  	 * pool on a given add */
> -	const int step = 5;
> +	const int step = 13;
>  
>  	/* Taps are constant, so we can load them without holding r->lock.  */
>  	tap1 = r->poolinfo->tap1;

This change has nothing to do with the patch comment.  If you want to
change the step size from 5 to 13, why not just change patch 5/6 to
just use a step size of 13 from the beginning?

Otherwise, yeah, this patch does make sense.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

								- Ted
