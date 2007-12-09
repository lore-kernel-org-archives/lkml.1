Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXLIBsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXLIBsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 20:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXLIBsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 20:48:31 -0500
Received: from THUNK.ORG ([69.25.196.29]:40578 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbXLIBsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 20:48:30 -0500
Date: Sat, 8 Dec 2007 20:48:20 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] random: step more rapidly through the pool when
	adding and extracting
Message-ID: <20071209014820.GV17037@thunk.org>
Mail-Followup-To: tytso@mit.edu, Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <6.753618428@selenic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.753618428@selenic.com>
1;1609;0cFrom: Theodore Tso <tytso@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: Theodore Tso <tytso@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 05:20:39PM -0600, Matt Mackall wrote:
> random: step more rapidly through the pool when adding and extracting
> 
> Second, this patch spreads the mixing across the pool more rapidly by
> using a larger step. For our secondary pools, we'll be sure to touch
> both blocks with each mix, and for our primary pool, we'll change 5 of
> 8 blocks.

Yeah, that's a good idea.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
