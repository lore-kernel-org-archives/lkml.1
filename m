Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYIXWxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYIXWxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYIXWxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:53:21 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:25479 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYIXWxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:53:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmAJAAZg2kh5LF82/2dsb2JhbACKP7McgWU
X-IronPort-AV: E=Sophos;i="4.33,303,1220193000"; 
   d="scan'208";a="214068124"
Date: Thu, 25 Sep 2008 08:53:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sylwester Gruszka <gruszex@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Broken XFS partition
Message-ID: <20080924225316.GL5448@disturbed>
Mail-Followup-To: Sylwester Gruszka <gruszex@gmail.com>,
	linux-kernel@vger.kernel.org
References: <200809241236.26135.gruszex@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809241236.26135.gruszex@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 12:36:25PM +0200, Sylwester Gruszka wrote:
> Hello,
> 
> I have a problem with XFS partition, it has broken down suddenly. I was doing 
> no special things, just browsing www and suddenly my PC has restarted, after 
> that I could not boot by PLD Th linux, after few usual kernel messages I get 
> some matrix of numbers and it stops.
> 
> I realised that it is broken partition after I tried to repair system, I just 
> could not mount this partition (using sysrescuecd), 'mount' gave me lots of 
> weird numbers instead of mounting partition. It only do that way at first try, 
> the second try always freezes mount program and nothing is happening.
> 
> Here are some screenshots (mount using SystemRescueCd-1.1.0 so the kernel is 
> propably 2.6.25.16):
> http://img397.imageshack.us/my.php?image=dsc01043ko6.jpg
> http://img179.imageshack.us/my.php?image=dsc01044yj4.jpg
> http://img158.imageshack.us/my.php?image=dsc01045sr3.jpg
> http://img221.imageshack.us/my.php?image=dsc01047js4.jpg

This indicates a corrupted log record is being incorrectly parsed.
Please try adding the patch I posted yesterrday that fixed a
fs-fuzzer triggered occurrence of the same oops....

http://oss.sgi.com/archives/xfs/2008-09/msg00296.html

This patch will prevent the oops, but you'll still need to manually
repair the damage to the FS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
