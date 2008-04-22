Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbYDVWH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbYDVWH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbYDVWHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:07:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43726 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757290AbYDVWHs (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:07:48 -0400
Date: Wed, 23 Apr 2008 08:07:25 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: do not pass unused params to xfs_flush_pages
Message-ID: <20080422220724.GB103491721@sgi.com>
References: <20080419142329.GA5339@elte.hu> <20080422012819.GT108924158@sgi.com> <200804220433.04030.vda.linux@googlemail.com> <200804220503.16888.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804220503.16888.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 05:03:16AM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> xfs_flush_pages() does not use some of its parameters, namely:
> first, last and fiops.

These were never removed because they are place holders for
stuff that Linux didn't support when the original port was done.
Now Linux supports range flushes, these functions should be changed
to do that, and hence the first/last parameters will be used.

But the fiopt flag can probably be killed....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
