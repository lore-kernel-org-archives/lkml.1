Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbYDVWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbYDVWef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbYDVWe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:34:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44713 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758606AbYDVWe1 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:34:27 -0400
Date: Wed, 23 Apr 2008 08:33:55 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: remove unused parameter of xfs_iomap_write_allocate
Message-ID: <20080422223355.GV108924158@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804220514.45191.vda.linux@googlemail.com> <200804221142.00914.vda.linux@googlemail.com> <200804221216.25905.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221216.25905.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 12:16:25PM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> xfs_iomap_write_allocate() does not use count parameter.

Hmmm - I'm wondering if that is actually a bug. Certainly the
code is in conflict with the comment for the function, and
it points out that I could have fixed a recent bug in a better
way.

I'm going to hold off this one until I've had time to look at this
in more detail....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
