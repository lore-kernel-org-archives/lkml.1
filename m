Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZCMWl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZCMWl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZCMWlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:41:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55014
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760060AbZCMWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:41:43 -0400
Date: Fri, 13 Mar 2009 15:41:29 -0700 (PDT)
Message-Id: <20090313.154129.08540488.davem@davemloft.net>
To: khali@linux-fr.org
Cc: marcin.slusarz@gmail.com, netdev@vger.kernel.org, afleming@freescale.com,
       tpiepho@freescale.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phylib: convert state_queue work to delayed_work
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090307104620.7f2aed57@hyperion.delvare>
References: <20090306205139.GA30500@joi>
	<20090307104620.7f2aed57@hyperion.delvare>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>
Date: Sat, 7 Mar 2009 10:46:20 +0100

> On Fri, 6 Mar 2009 21:51:42 +0100, Marcin Slusarz wrote:
> > It closes a race in phy_stop_machine when reprogramming of phy_timer
> > (from phy_state_machine) happens between del_timer_sync and cancel_work_sync.
> > 
> > Without this change it could lead to crash if phy_device would be freed after
> > phy_stop_machine (timer would fire and schedule freed work).
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Andy Fleming <afleming@freescale.com>
> > Cc: Trent Piepho <tpiepho@freescale.com>
> > ---
> > 
> > This patch was only compile tested.
> 
> Patch looks good.
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>

Applied, thanks.
