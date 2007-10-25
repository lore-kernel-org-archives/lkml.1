Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXJYQD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXJYQD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXJYQDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:03:20 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:61752 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXJYQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:03:19 -0400
Date: Fri, 26 Oct 2007 01:05:10 +0900 (JST)
Message-Id: <20071026.010510.59032545.anemo@mba.ocn.ne.jp>
To: rmk+lkml@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] serial: do not call ->pm() on initialization for
 console port
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20071018161827.GB16244@flint.arm.linux.org.uk>
References: <20071019.011355.39154656.anemo@mba.ocn.ne.jp>
	<20071018161827.GB16244@flint.arm.linux.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 17:18:27 +0100, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > Attached patch fixes this problem.  Is this a right way?
> > If not, I will fix the serial_txx9 driver to skip the initialization in
> > ->pm() if oldstate was -1.
> 
> I'll have to investigate further to refresh myself with what's going
> on here, but your patch looks wrong.

Now rc1 is released.  Any chances for this patch?
If none, I should push other workaround to fix this issue on 2.6.24.

---
Atsushi Nemoto
