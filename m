Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYJCHDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYJCHDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYJCHCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:02:51 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35690 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYJCHCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:02:50 -0400
Date: Fri, 3 Oct 2008 09:02:43 +0200
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Tino Keitel <tino.keitel@gmx.de>, netdev@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] sky2: Fix recent WOL regression
Message-ID: <20081003090243.724cf79c@speedy>
In-Reply-To: <200810022339.34025.rjw@sisk.pl>
References: <200810022339.34025.rjw@sisk.pl>
Organization: Vyatta
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 23:39:33 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> sky2: Fix recent WOL regression
> 
> Since dev->power.should_wakeup bit is used by the PCI core to
> decide whether the device should wake up the system from sleep
> states, set/unset this bit whenever WOL is enabled/disabled using
> sky2_set_wol() (this fixes a regression from 2.6.26 on the Tino's
> machine).
> 
> Remove an open-coded reference to the standard PCI PM registers that
> is not used any more.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Tino Keitel <tino.keitel@gmx.de>
> ---

Acked-by: Stephen Hemminger <shemminger@vyatta.com>

Thanks for fixing this.
