Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXLKSIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXLKSIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXLKSI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:08:27 -0500
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:53288
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbXLKSI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:08:26 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 13:08:26 EST
Subject: Re: 2.6.24-rc3-mm1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
In-Reply-To: <20071126221509.8f437b61.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <47462F3C.3040700@googlemail.com>
	 <20071122201250.f957e280.akpm@linux-foundation.org>
	 <47466B5D.90607@googlemail.com>
	 <20071126221509.8f437b61.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 11:33:03 -0500
Message-Id: <1197390783.3812.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-26 at 22:15 -0800, Andrew Morton wrote:
> OK, thanks.  I'll assume that James and Hannes have this in hand (or will
> have, by mid-week) and I won't do anything here.

Just to confirm what I think I'm going to be doing:  rebasing the
scsi-misc tree to remove this commit:

commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Nov 6 09:23:40 2007 +0100

    [SCSI] Do not requeue requests if REQ_FAILFAST is set

And its allied fix ups:

commit 983289045faa96fba8841d3c51b98bb8623d9504
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Nov 24 19:47:25 2007 +0200

    [SCSI] fix up REQ_FASTFAIL not to fail when state is QUIESCE

commit 9dd15a13b332e9f5c8ee752b1ccd9b84cb5bdf17
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Nov 24 19:55:53 2007 +0200

    [SCSI] fix domain validation to work again

James


