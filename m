Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYFBB71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYFBB71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYFBB7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:59:17 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:21662 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbYFBB7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:59:16 -0400
Date: Mon, 2 Jun 2008 11:58:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tom Spink <tspink@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [RFC PATCH 0/2] On-demand Filesystem Initialisation
Message-ID: <20080602015831.GB2428@disturbed>
Mail-Followup-To: Tom Spink <tspink@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
References: <1212331915-22856-1-git-send-email-tspink@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212331915-22856-1-git-send-email-tspink@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 03:51:53PM +0100, Tom Spink wrote:
> 
> (resend to include CCs)

What cc's? Still no xfs cc on it. I added it to this reply....

> This (short) patch series is another RFC for the patch that introduces on-demand
> filesystem initialisation.  In addition to the original infrastructure
> implementation (with clean-ups), it changes XFS to use this new infrastructure.
> 
> I wrote a toy filesystem (testfs) to simulate scheduling/allocation delays and
> to torture the mount/unmount cycles.  I didn't manage to deadlock the system
> in my tests.  XFS also works as expected aswell, in that the global threads
> are not created until an XFS filesystem is mounted for the first time.  When the
> last XFS filesystem is unmounted, the threads go away.
> 
> Please let me know what you think!

Why even bother? This is why we have /modular/ kernels - if you're
not using XFS then don't load it and you won't see those pesky
threads. That'll save on a bunch of memory as well because the xfs
module ain't small (>480k on i386)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
