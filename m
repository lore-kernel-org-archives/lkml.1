Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbXLLTCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbXLLTCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbXLLTCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:02:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55580
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbXLLTCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:02:43 -0500
Date: Wed, 12 Dec 2007 11:02:43 -0800 (PST)
Message-Id: <20071212.110243.202840959.davem@davemloft.net>
To: gallatin@myri.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][NETDEV]: remove netif_running() check from
 myri10ge_poll()
From: David Miller <davem@davemloft.net>
In-Reply-To: <47602AAA.8060204@myri.com>
References: <47602AAA.8060204@myri.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Gallatin <gallatin@myri.com>
Date: Wed, 12 Dec 2007 13:38:34 -0500

> Remove the bogus netif_running() check from myri10ge_poll().
> 
> This eliminates any chance that myri10ge_poll() can trigger
> an oops by calling netif_rx_complete() and returning
> with work_done == budget.
> 
> Signed-off-by: Andrew Gallatin <gallatin@myri.com>

Acked-by: David S. Miller <davem@davemloft.net>
