Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbXGPAde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbXGPAde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbXGPAd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:33:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56528 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243AbXGPAdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:33:25 -0400
Date: Mon, 16 Jul 2007 02:33:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 4/8] Immediate Value - Add kconfig menus
Message-ID: <20070716003322.GA26835@one.firstfloor.org>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.839969254@polymtl.ca> <20070714072801.GB5822@martell.zuzino.mipt.ru> <20070714152734.GB4737@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714152734.GB4737@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On embedded systems, the tradeoff is not the same. The immediate values
> trade a little bit of system memory (to keep the pointers to the
> variable and instruction as well as the size of the variable, only used
> when the variable is updated) in order to remove cache line hot paths.

Please remove the Kconfig. I don't think it makes sense. Such optimizations
should be always enabled. We don't have CONFIG_GO_FASTER configs normally.
Don't introduce them now.

> 
> Also, embedded systems with physically read-only memory clearly does not
> want to enable this.

We always patch the x86 kernel, so they have to deal with it anyways.
The x86 port doesn't support XIP.

-Andi
