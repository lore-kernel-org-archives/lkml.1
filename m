Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbZATAqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbZATAqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760135AbZATAqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:46:20 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:14131 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759958AbZATAqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:46:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMmqdEl5LBUR/2dsb2JhbADOQ4Vz
X-IronPort-AV: E=Sophos;i="4.37,292,1231075800"; 
   d="scan'208";a="287789404"
Date: Tue, 20 Jan 2009 11:46:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120004611.GA6445@disturbed>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
	xfs mailing list <xfs@oss.sgi.com>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974CA20.6050308@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 12:44:48PM -0600, Eric Sandeen wrote:
> Jacek Luczak wrote:
> > Hi All,
> > 
> > I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
> > didn't found errors. Today I've booted my notebook and XFS bug have occurred.
> > System reboot didn't helped, same error appeared.
> > 
> > Some info:
> > [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
> > [2] kernel logs:
> > http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
> > [3] most interesting part of log below.
> 
> so this happens every mount?  Reproducible is good.  How large is the
> filesystem (too large to extract elsewhere for analysis...?) (plus I
> suppose it'll be hard to get to it when you can't even boot....)

XFS folks, I suspect the common link between all the reports of this
bug is that they are on 32-bit kernels. I can't reproduce this on
a 64 bit kernel, and I'm trying to get a 32-bit UML built right now
to test this theory.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
