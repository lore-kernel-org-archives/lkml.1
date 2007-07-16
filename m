Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbXGPKgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbXGPKgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbXGPKf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:35:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54365 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXGPKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:35:57 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Mon, 16 Jul 2007 12:35:41 +0200
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu>
In-Reply-To: <20070716091236.GA10718@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161235.42637.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 11:12, Ingo Molnar wrote:
> After a bisection session the bad commit turned out to be:
> 
>  29578624e354f56143d92510fff33a8b2aaa2c03 is first bad commit
>  commit 29578624e354f56143d92510fff33a8b2aaa2c03
>  Author: Olaf Kirch <olaf.kirch@oracle.com>
>  Date:   Wed Jul 11 19:32:02 2007 -0700
> 
>      [NET]: Fix races in net_rx_action vs netpoll.
> 
>      Keep netpoll/poll_napi from messing with the poll_list.
>      Only net_rx_action is allowed to manipulate the list.
> 
>      Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>

Apologies - I'll look into it.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
