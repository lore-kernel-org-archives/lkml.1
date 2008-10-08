Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYJHXMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYJHXMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYJHXMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:12:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56299
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbYJHXMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:12:34 -0400
Date: Wed, 08 Oct 2008 16:12:10 -0700 (PDT)
Message-Id: <20081008.161210.79287275.davem@davemloft.net>
To: rjw@sisk.pl
Cc: shemminger@vyatta.com, jeff@garzik.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       tino.keitel@gmx.de, netdev@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] sky2: Fix recent WOL regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <200810090055.56598.rjw@sisk.pl>
References: <200810022339.34025.rjw@sisk.pl>
	<20081003090243.724cf79c@speedy>
	<200810090055.56598.rjw@sisk.pl>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 9 Oct 2008 00:55:55 +0200

> On Friday, 3 of October 2008, Stephen Hemminger wrote:
> > On Thu, 2 Oct 2008 23:39:33 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > sky2: Fix recent WOL regression
> > > 
> > > Since dev->power.should_wakeup bit is used by the PCI core to
> > > decide whether the device should wake up the system from sleep
> > > states, set/unset this bit whenever WOL is enabled/disabled using
> > > sky2_set_wol() (this fixes a regression from 2.6.26 on the Tino's
> > > machine).
> > > 
> > > Remove an open-coded reference to the standard PCI PM registers that
> > > is not used any more.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > Reported-by: Tino Keitel <tino.keitel@gmx.de>
> > > ---
> > 
> > Acked-by: Stephen Hemminger <shemminger@vyatta.com>
> > 
> > Thanks for fixing this.
> 
> Can you please include this patch into your next push for Jeff?
> 
> It seems to have been overlooked.

I missed this ACK but I did add the patch to my tree as you
can see from another email of mine.
