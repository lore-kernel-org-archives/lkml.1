Return-Path: <linux-kernel-owner+w=401wt.eu-S936726AbXLQV6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936726AbXLQV6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbXLQV6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:58:33 -0500
Received: from THUNK.ORG ([69.25.196.29]:49238 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761351AbXLQV6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:58:32 -0500
Date: Mon, 17 Dec 2007 16:58:24 -0500
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071217215824.GI7070@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, protasnb@gmail.com
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217133631.5bbc5842@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 01:36:31PM -0800, Arjan van de Ven wrote:
> Subject: [patch] terminate the oops printing with a defined string/uuid
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> Right now, it's hard for automated tools to determine when an oops has
> ended; there's no clear marker for this. In addition, there's no good
> way to find out if an oops is unique. Sometimes it's the same oops
> just reported multiple times, while other times it's a different
> instance of the crash with the same signature. Printing the boot UUID
> as part of the end string resolves this ambiguity.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ted Ts'o <tytso@thunk.org>

Looks good to me!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
