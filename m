Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbYDVWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbYDVWJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbYDVWJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:09:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55409 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757158AbYDVWJK (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:09:10 -0400
Date: Wed, 23 Apr 2008 08:08:45 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: use smaller int param in call to xfs_flush_pages
Message-ID: <20080422220845.GC103491721@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804220433.04030.vda.linux@googlemail.com> <200804220503.16888.vda.linux@googlemail.com> <200804220514.45191.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804220514.45191.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 05:14:45AM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> xfs_flush_pages() flags parameter is declared as uint64_t, but
> code never pass values which do not fit into 32 bits.
> All callsites sans one pass zero, and the last one passes
> XFS_B_DELWRI, XFS_B_ASYNC or zero.
> These values are defined in enum xfs_buf_flags_t and they
> all fit in 32 bits.

Can you fold this into the previous patch that kills fiopt to
this function?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
