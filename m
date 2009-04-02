Return-Path: <linux-kernel-owner+w=401wt.eu-S1765940AbZDBXdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765940AbZDBXdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762837AbZDBXcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:32:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54624
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762623AbZDBXcq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:32:46 -0400
Date: Thu, 02 Apr 2009 16:32:35 -0700 (PDT)
Message-Id: <20090402.163235.153382360.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: markus@trippelsdorf.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, uwe.bugla@gmx.de
Subject: Re: [PATCH 2/2] tcp: miscounts due to tcp_fragment pcount reset
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0904021216170.30150@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0904011352470.30150@wrl-59.cs.helsinki.fi>
	<Pine.LNX.4.64.0904021212310.30150@wrl-59.cs.helsinki.fi>
	<Pine.LNX.4.64.0904021216170.30150@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 2 Apr 2009 12:18:20 +0300 (EEST)

> 
> It seems that trivial reset of pcount to one was not sufficient
> in tcp_retransmit_skb. Multiple counters experience a positive
> miscount when skb's pcount gets lowered without the necessary
> adjustments (depending on skb's sacked bits which exactly), at
> worst a packets_out miscount can crash at RTO if the write queue
> is empty!
> 
> Triggering this requires mss change, so bidir tcp or mtu probe or
> like.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Tested-by: Uwe Bugla <uwe.bugla@gmx.de>

Applied.
