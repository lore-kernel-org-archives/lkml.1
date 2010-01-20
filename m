Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801Ab0ATWox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0ATWox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786Ab0ATWov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:44:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60211
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab0ATWou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:44:50 -0500
Date: Wed, 20 Jan 2010 14:45:00 -0800 (PST)
Message-Id: <20100120.144500.40591155.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: mchan@broadcom.com, jarkao2@gmail.com, mbreuer@majjas.com,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pcnet32@verizon.net, romieu@fr.zoreil.com, mcarlson@broadcom.com
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902 check_sync
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100120123033.0746b11e@nehalam>
References: <20100120100316.2b5b1b05@nehalam>
	<1264018312.9030.76.camel@nseg_linux_HP1.broadcom.com>
	<20100120123033.0746b11e@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 20 Jan 2010 12:30:33 -0800

> It looks like the size passed to sync_single has to match size of original
> mapping.

I think that's rediculious, and unreasonable.

All implementations of these APIs where the sync matters have the
ability to handle partial syncs correctly.
