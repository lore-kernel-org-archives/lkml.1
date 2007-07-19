Return-Path: <linux-kernel-owner+w=401wt.eu-S935992AbXGSRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935992AbXGSRxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965263AbXGSRxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:53:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34147 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965213AbXGSRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:53:11 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 19:51:14 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
References: <20070716091236.GA10718@elte.hu> <20070719160556.GA3330@elte.hu> <200707191936.12646.olaf.kirch@oracle.com>
In-Reply-To: <200707191936.12646.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191951.15675.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 19:36, Olaf Kirch wrote:
> Can you confirm this by spraying the laptop with arp packets
> or broadcast pings while it's booting?

Sorry for the noise - didn't see your other message where you
described just that.

This sounds more like a hardware issue - Rx interrupt seems to
go through (triggering all the usual NAPI cleanup), but the Tx
descriptor writeback interrupt doesn't.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
