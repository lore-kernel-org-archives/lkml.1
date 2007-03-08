Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbXCHDvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbXCHDvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXCHDvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:51:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39599
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbXCHDvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:51:37 -0500
Date: Wed, 07 Mar 2007 19:51:35 -0800 (PST)
Message-Id: <20070307.195135.74749102.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: w@1wt.eu, rkuhn@e18.physik.tu-muenchen.de, andi@firstfloor.org,
       dada1@cosmosbay.com, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp_cubic: use 32 bit math
From: David Miller <davem@davemloft.net>
In-Reply-To: <45EF7EB7.8040806@linux-foundation.org>
References: <20070307170731.2b4397e3@freekitty>
	<20070307.185539.48527371.davem@davemloft.net>
	<45EF7EB7.8040806@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 07 Mar 2007 19:10:47 -0800

> David Miller wrote:
> > What about Willy Tarreau's supposedly even faster variant?
> > Or does this incorporate that set of improvements?
> >   
> That's what this is:
>     x = (2 * x + (uint32_t)div64_64(a, (uint64_t)x*(uint64_t)x)) / 3;

Great, thanks for the clarification.
