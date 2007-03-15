Return-Path: <linux-kernel-owner+w=401wt.eu-S1422762AbXCOAIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422762AbXCOAIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422765AbXCOAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:08:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422762AbXCOAII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:08:08 -0400
Date: Wed, 14 Mar 2007 17:07:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.21-rc3-mm1
Message-Id: <20070314170738.d5d35c06.akpm@linux-foundation.org>
In-Reply-To: <200703142006.04547.m.kozlowski@tuxland.pl>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
	<200703142006.04547.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 14 Mar 2007 20:06:02 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> Hello,
> 
> 	Today after +- 24h of uptime I found some more page allocation
> failures ('eth1: Can't allocate skb for Rx'). You'll find more here:
> 
> http://tuxland.pl/misc/2.6.21-rc3-mm1-page-allocation-failure.txt
> 
> System wasn't doing anything unusual, as usual ;-) X, some p2p 
> software, firefox+flash playing music.
> 

Do other kernels do this, or is 2.6.21-rc3-mm1 worse?

It is of course a non-fatal problem and will inevitably happen sometimes,
but we would like the VM to be able to minimise the occurrence of this
problem.

I think we were rather hoping that Mel's anti-fragmentation work would
improve things.
