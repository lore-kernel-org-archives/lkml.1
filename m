Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbXA3Wuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbXA3Wuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXA3Wux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:50:53 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:21794 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbXA3Wuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:50:52 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="36146010:sNHT1664041887"
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com>
	<45BFC7F2.7090209@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 14:50:49 -0800
In-Reply-To: <45BFC7F2.7090209@garzik.org> (Jeff Garzik's message of "Tue, 30 Jan 2007 17:34:26 -0500")
Message-ID: <adaac00p1rq.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 22:50:49.0523 (UTC) FILETIME=[1633F830:01C744C1]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Which of these actively maintained and supported drivers work on only
 > one platform[1], and are excluded from enterprise distros?  Can we
 > truly count them as "many", as you repeatedly claim?

Why do we restrict this to actively maintained and supported drivers
(I think abandonware drivers are highly relevant here...)?  And why
are you asking about drivers that work on only one platform?  Greg
promised support for every platform that has the right bus to plug a
device into.  So things like drivers that don't work on SMP or 64-bit
or big-endian platforms also violate that pledge, even if there's more
than one 32-bit little-endian uniprocessor platform where the driver
does work.

Anyway, grepping for stuff like BROKEN or !64BIT or X86 in the Kconfig
dependencies under drivers/ finds tons of hits.  I don't have time to
scan through and figure out which meet your criteria, and I honestly
don't know how enterprise distros decide what to support.  For example
RHEL4 seems to ship aha152x (which depends on ISA && SCSI && !64BIT),
but what will RH do if someone actually wants support for it?

I don't really understand why it's so hard to accept that sometimes
even open specs aren't enough to get great Linux support.

 - R.
