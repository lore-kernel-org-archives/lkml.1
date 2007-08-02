Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbXHBJ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbXHBJ0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbXHBJ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:26:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35632
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbXHBJ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:26:36 -0400
Date: Thu, 02 Aug 2007 02:26:37 -0700 (PDT)
Message-Id: <20070802.022637.10299486.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Removal of FASTROUTE definition
 include/linux/if_packet.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0708020223o521e89b9v3200e06ab296df12@mail.gmail.com>
References: <eb3ff54b0708020223o521e89b9v3200e06ab296df12@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Thu, 2 Aug 2007 12:23:41 +0300

> Hi,
>   It seems that PACKET_FASTROUTE definition should be removed due to that
> 	fastroute is no longer supported.

It's a value exported to userland, so removing it could
break application compilation, so we can't remove it.
