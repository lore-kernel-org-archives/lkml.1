Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXDLVEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXDLVEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXDLVEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:04:08 -0400
Received: from www.osadl.org ([213.239.205.134]:38920 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753743AbXDLVEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:04:07 -0400
Subject: RE: sched_yield proposals/rationale
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Buytaert_Steven@emc.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
In-Reply-To: <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com>
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com>
	 <p737ish90ss.fsf@bingen.suse.de>
	 <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com>
	 <20070412133158.GB31455@one.firstfloor.org>
	 <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 23:04:58 +0200
Message-Id: <1176411899.28263.704.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-12 at 10:15 -0400, Buytaert_Steven@emc.com wrote:
> > -----Original Message-----
> > > Agreed, but $ find . -name "*.[ch]" | xargs grep -E "yield[ ]*\(" | wc
> > over
> > > the 2.6.16 kernel yields 105 hits, note including comments... An
> > interesting spot is e.g. fs/buffer.c free_more_memory()
> > 
> > A lot of those are probably broken in some way agreed.
> 
> OK, so there are 2 options: 1) fix 100 spots or 2) ... ;-)

100, simply because at least 95 of them are broken.

	tglx


