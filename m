Return-Path: <linux-kernel-owner+w=401wt.eu-S938483AbXGSP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938483AbXGSP2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbXGSP2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:28:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26203 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbXGSP2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:28:24 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 17:27:26 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
References: <20070716091236.GA10718@elte.hu> <20070719105816.GA15852@elte.hu> <20070719150728.GA17000@elte.hu>
In-Reply-To: <20070719150728.GA17000@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191727.27662.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 17:07, Ingo Molnar wrote:
> i crashed the laptop in a weird way and had to power-cycle it in an 
> unusual fashion. After that i wanted to try your latest BUG_ON() theory 
> but the network hang went away!

Should I rejoice, or regret? :-)

> maybe it's not the power-cycling that somehow brought the e1000 out of 
> its weird state but the ethtool ops (and the related firmware readouts, 
> etc.)?

Oh, don't tell me there's a --scrub-bad-karma switch in ethtool.

> (i have your BUG_ON() applied (as a WARN_ON()), but it doesnt trigger. 
> Not that this means anything under these circumstances ...)

Too bad. Now where do we take it from here? I'm currently thinking of
ways to do this patch differently. But that is kind of relying on a
good testbed to verify whether a different patch works better for you
or not...

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
