Return-Path: <linux-kernel-owner+w=401wt.eu-S1764258AbXLPWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764258AbXLPWEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760300AbXLPWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:04:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42721
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759823AbXLPWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:04:40 -0500
Date: Sun, 16 Dec 2007 14:04:25 -0800 (PST)
Message-Id: <20071216.140425.19234188.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, den@openvz.org,
       xemul@openvz.org
Subject: Re: [PACKET]: Fix /proc/net/packet crash due to bogus private
 pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071216034119.GA1491@gondor.apana.org.au>
References: <200712160118.58611.m.kozlowski@tuxland.pl>
	<E1J3jqN-0000Jq-00@gondolin.me.apana.org.au>
	<20071216034119.GA1491@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 16 Dec 2007 11:41:20 +0800

> [PACKET]: Fix /proc/net/packet crash due to bogus private pointer
> 
> The seq_open_net patch changed the meaning of seq->private.
> Unfortunately it missed two spots in AF_PACKET, which still
> used the old way of dereferencing seq->private, thus causing
> weird and wonderful crashes when reading /proc/net/packet.
> 
> This patch fixes them.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied to net-2.6.25, thanks Herbert.
