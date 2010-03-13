Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab0CMUM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:12:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55813
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759163Ab0CMUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:12:26 -0500
Date: Sat, 13 Mar 2010 12:12:48 -0800 (PST)
Message-Id: <20100313.121248.76758764.davem@davemloft.net>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] fix PHY polling system blocking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268484790.6339.37.camel@wall-e>
References: <1268484790.6339.37.camel@wall-e>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>
Date: Sat, 13 Mar 2010 13:53:10 +0100

> For PHY chips without interrupts, the status of the ethernet will be
> polled every 2 sec. The poll function will read some register of the MII
> PHY. The time between the sending the MII_READ_COMMAND and receiving the
> result could be very long (>100us).

I'm not apply this, as I described in my previous email.

If it's expensive to detect link configuration changes that
doesn't mean you just turn it off.
