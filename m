Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbXIRSXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbXIRSXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXIRSXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:23:46 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:42123
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbXIRSXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:23:45 -0400
Date: Tue, 18 Sep 2007 11:23:37 -0700 (PDT)
Message-Id: <20070918.112337.74737433.davem@davemloft.net>
To: mchan@broadcom.com
Cc: vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
From: David Miller <davem@davemloft.net>
In-Reply-To: <1190141114.9540.216.camel@dell>
References: <200709181823.26429.vda.linux@googlemail.com>
	<1190141114.9540.216.camel@dell>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Tue, 18 Sep 2007 11:45:14 -0700

> On Tue, 2007-09-18 at 18:23 +0100, Denys Vlasenko wrote:
> > Do you have any plans to switch to request_firmware() interface,
> > which will allow you to avoid keeping firmware in unswappable kernel
> > memory and thus free ~80k?
> 
> Matching the correct version of the firmware with the driver is the main
> issue.
> 
> David, what's your opinion on this?

I don't like it because it means people have to setup full initrd's
in order to do network booting with such network cards.

But the days of my opinion mattering on that issue are long gone,
the momentum is just too greatly behind using request_firmware()
across the board, so there is no reason for bnx2 to be any different.
