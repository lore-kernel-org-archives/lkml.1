Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYGKTCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYGKTCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYGKTCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:02:16 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39863 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbYGKTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:02:14 -0400
Date: Fri, 11 Jul 2008 21:02:09 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Dave Chinner <david@fromorbit.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080711084248.GU29319@disturbed>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Chinner | 2008-07-11 18:42:49 [+1000]:

>Oh - you must be running a debug XFS.  CONFIG_XFS_DEBUG was only
>introduced in 2.6.26-rc1 and defaults to 'N', so you must have
>selected the non-default option when prompted. This will cause your
>machine to oops at the slightest inconsistency that is found,
>regardless of whether it is fatal or not. Like the help text says,
>don't set this unless you are an XFS developer....
Could you please add this to the Kconfig entry. Debug mode is usually
noisy, little slower and mostly usefull just to the developers but *I*
would not expect to BUG() in the non-fatal case.
Not sure but if this is just for hch and you than a define in xfs.h
might be safer :)

>Dave.
Sebastian
