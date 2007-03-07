Return-Path: <linux-kernel-owner+w=401wt.eu-S2992506AbXCGTdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992506AbXCGTdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992502AbXCGTdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:33:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34588
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992493AbXCGTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:33:06 -0500
Date: Wed, 07 Mar 2007 11:33:03 -0800 (PST)
Message-Id: <20070307.113303.04008211.davem@davemloft.net>
To: andi@firstfloor.org
Cc: shemminger@linux-foundation.org, rkuhn@e18.physik.tu-muenchen.de,
       dada1@cosmosbay.com, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp_cubic: faster cube root
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070307121246.GA7728@one.firstfloor.org>
References: <20070306144706.4585c079@freekitty>
	<20070306.202052.03980320.davem@davemloft.net>
	<20070307121246.GA7728@one.firstfloor.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 7 Mar 2007 13:12:46 +0100

> Well that still needs the ugly div64_64 function. At least my goal was to 
> eliminate that, not make it faster (I don't see any evidence this function 
> is particularly performance critical). You prefer to keep div64_64? 

I really have no issues with it.
