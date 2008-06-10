Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbYFJWUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbYFJWUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbYFJWTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:19:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38924 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbYFJWTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:19:49 -0400
Message-ID: <484EFDFC.3040206@garzik.org>
Date: Tue, 10 Jun 2008 18:19:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nicolas 2P <nicolas.2p.debian@free.fr>
CC: Jay Vosburgh <fubar@us.ibm.com>, David Miller <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch]  bondig - arp_interval with low value => Oops.
References: <482C9E73.2040202@free.fr>
In-Reply-To: <482C9E73.2040202@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas 2P wrote:
> When setting arp_interval parameter to a very low value, delta_in_ticks 
> for next arp might become 0, causing an infinite loop.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=10680
> 
> Same problem for miimon parameter already fixed, but fix might be 
> enhanced, by using msecs_to_jiffies() function.
> 
> Signed-off-by: Nicolas de Pesloüan <nicolas.2p.debian@free.fr>

I don't see an ACK from Jay in my mbox?

Certainly looks nicer than adding "? : 1" to each of the remaining two 
cases.


