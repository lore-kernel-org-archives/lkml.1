Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYGXU7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYGXU7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYGXU7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:59:36 -0400
Received: from mail.vyatta.com ([216.93.170.194]:45259 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYGXU7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:59:36 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.671
Date: Thu, 24 Jul 2008 13:59:33 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] sky2: Adapt sky2 to use reworked PCI PM
Message-ID: <20080724135933.71d3572c@extreme>
In-Reply-To: <200807242250.51119.rjw@sisk.pl>
References: <200807191436.40726.rjw@sisk.pl>
	<200807191442.52759.rjw@sisk.pl>
	<20080720190742.84258d7e.akpm@linux-foundation.org>
	<200807242250.51119.rjw@sisk.pl>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 22:50:50 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> [Sorry for the delayed response, I'm at OLS.]
> 
> On Monday, 21 of July 2008, Andrew Morton wrote:
> > On Sat, 19 Jul 2008 14:42:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Adapt the sky2 driver to use the reworked PCI PM.
> > 
> > I fixed the rejects in "[PATCH 3/4] tg3: Adapt tg3 to use reworked PCI
> > PM code" but this patch has too many for me to want to fix them.
> > 
> > As usual, please at least take a look at what's in linux-next before
> > going and bypassing all that queued work.
> 
> Sorry for that.
> 
> Appended is a version of the patch applying to the current mainline on top of
> patches 1/4 - 3/4 without rejects.
> 
> BTW, the sky2's WOL is broken on my test box because of commit
> db99b98885e717454feef1c6868b27d3f23c2e7c ("sky2: put PHY in sleep when down")
> that causes the box to hang solid in sky2_suspend() and sky2_shutdown() after
> WOL has been enabled with 'ethtool -s eth0 wol g'.
> 
> This has already been reported to Stephen and Jeff.
> 
> Thanks,
> Rafael

Please wait, I am working on a better stable way to do this.
