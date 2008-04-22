Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYDVWDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYDVWDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYDVWC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:02:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38700 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755881AbYDVWC4 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:02:56 -0400
Date: Wed, 23 Apr 2008 08:02:20 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: do not pass size into kmem_free, it's unused
Message-ID: <20080422220220.GA103491721@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804212151.02241.vda.linux@googlemail.com> <20080422012819.GT108924158@sgi.com> <200804220433.04030.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804220433.04030.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 04:33:03AM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> > Patches are welcome - I'd be over the moon if any of the known 4k
> > stack advocates sent a stack reduction patch for XFS, but it seems
> > that actually trying to fix the problems is much harder than
> > resending a one line patch every few months....
> 
> kmem_free() function takes (ptr, size) arguments but doesn't
> actually use second one.

Ack. Pulled into my qa tree.

FWIW, can you send patches in line next time? It makes it easier to
quote them on review....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
