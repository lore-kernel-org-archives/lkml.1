Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbXJBTFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbXJBTFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 15:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXJBTFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 15:05:01 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:34230 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752559AbXJBTFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 15:05:00 -0400
Subject: Re: [git patch] SCSI aic94xx fix
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <470293C7.6080906@garzik.org>
References: <20071002172151.GA28579@havoc.gtf.org>
	 <1191350862.3530.114.camel@localhost.localdomain>
	 <470293C7.6080906@garzik.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 14:04:58 -0500
Message-Id: <1191351898.3530.116.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 14:53 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > Sure, I'll state my case:  This is a bug, but it has no affected users,
> > nor will it because the aic94xx doesn't work on non-x86 architectures by
> > reason of other longstanding bugs (and TODEVICE/FROMDEVICE only matters
> 
> False.  It fails to work on _some_ non-x86 platforms.

OK, it fails to work on everything I can test, which is parisc, ia64 and
ppc.  However, I'm fairly certain there are no other non-x86 users
because we have no bug reports.

James


