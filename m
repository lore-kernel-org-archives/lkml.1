Return-Path: <linux-kernel-owner+w=401wt.eu-S1764818AbXGPMUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764818AbXGPMUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXGPMT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:19:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17163 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbXGPMT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:19:56 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: David Miller <davem@davemloft.net>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Mon, 16 Jul 2007 14:18:41 +0200
User-Agent: KMail/1.9.1
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net>
In-Reply-To: <20070716.042640.18306462.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161418.42852.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 13:26, David Miller wrote:
> Well, let's figure out why before we revert because it
> is attempting to fix a legitimate bug.
> 
> Olaf, any ideas?

It seems as if the card is stuck in NAPI mode without being
serviced by net_rx_action.

Ingo, is this a UP or SMP machine? Are you still getting output
from netconsole, or is the network down completely?

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
