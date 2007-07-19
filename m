Return-Path: <linux-kernel-owner+w=401wt.eu-S939179AbXGSRhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939179AbXGSRhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbXGSRg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:36:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27979 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXGSRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:36:55 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 19:36:10 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
References: <20070716091236.GA10718@elte.hu> <20070719155230.GA31267@elte.hu> <20070719160556.GA3330@elte.hu>
In-Reply-To: <20070719160556.GA3330@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191936.12646.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 18:05, Ingo Molnar wrote:
> that network-intense test also produced periodic broadcast packets that 
> got the e1000 out of its weird state before the tx timeout could hit. 
> Now that i've stopped the test, the network is quiescent again and the 
> e1000 hangs.

Can you confirm this by spraying the laptop with arp packets
or broadcast pings while it's booting?

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
