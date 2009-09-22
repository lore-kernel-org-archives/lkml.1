Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZIVH4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZIVH4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZIVH4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:56:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbZIVH4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:56:08 -0400
Date: Tue, 22 Sep 2009 09:56:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mike Frysinger <vapier@gentoo.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>
Subject: RE: [PATCH] input/keyboard: new driver for ADP5520 MFD PMICs
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0DFAD237@limkexm3.ad.analog.com>
Message-ID: <alpine.LNX.2.00.0909220954360.17028@wotan.suse.de>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org> <20090922055954.GB9658@core.coreip.homeip.net> <alpine.LRH.2.00.0909220933090.27145@twin.jikos.cz> <8A42379416420646B9BFAC9682273B6D0DFAD237@limkexm3.ad.analog.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Hennerich, Michael wrote:

> >It actually doesn't seem to be the same condition (KP_INT vs. KR_INT), 
> >but it's difficult to say, as these constants are apparently added in 
> >some other patch I have no idea about.
> 
> KP Key-Press versus Key-Release 
> 
> >And the same for other constants used in the code ... the patch seems to
> >be quite incomplete.
> 
> The missing constants are in include/linux/mfd/adp5520.h
> 
> This file was sent in a different patch, adding support for the Multi Function Device Core 
> (drivers/mfd/adp5520.c)

The dependency on another patch should be either at least expressed in the 
patch Changelog, or even better send the patches as series with proper 
numbering, so that the dependency is obvious.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
