Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbXKPOqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbXKPOqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXKPOqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:46:35 -0500
Received: from stinky.trash.net ([213.144.137.162]:45556 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXKPOqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:46:34 -0500
Message-ID: <473DAD42.60603@trash.net>
Date: Fri, 16 Nov 2007 15:46:26 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Joonwoo Park <joonwpark81@gmail.com>, netdev@vger.kernel.org,
       "'David Miller'" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       greearb@candelatech.com, w@1wt.eu, cfriesen@nortel.com,
       djohnson+linux-kernel@sw.starentnetworks.com,
       e1000-devel@lists.sourceforge.net,
       "'Kok, Auke'" <auke-jan.h.kok@intel.com>
Subject: Re: FW: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
References: <006601c82846$b0f99eb0$9c94fea9@jason> <20071116143348.GA10596@gondor.apana.org.au>
In-Reply-To: <20071116143348.GA10596@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> BTW, how does the VLAN TX acceleration work at all? It's using
> skb->cb to carry the tags but then calls dev_queue_xmit.  Once
> you do that packet schedulers can scribble all over skb->cb.
> 
> Also vlan_skb_recv should be moved out-of-line.  It's absolutely
> humongous.  It'll generate tail-calls anyway so performance-wise
> it's useless.


I have a number of VLAN cleanups queued and intend to do these
two changes on top.

