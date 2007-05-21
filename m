Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbXEUIZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbXEUIZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXEUIZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:25:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39029
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXEUIZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:25:40 -0400
Date: Mon, 21 May 2007 01:25:41 -0700 (PDT)
Message-Id: <20070521.012541.112621369.davem@davemloft.net>
To: mingo@elte.hu
Cc: kernel@prachanda.info, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: bad networking related lag in v2.6.22-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070521075824.GA11198@elte.hu>
References: <20070518102607.GA23151@elte.hu>
	<200705200246.22444.kernel@prachanda.hub>
	<20070521075824.GA11198@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 May 2007 09:58:24 +0200

> what does 'top' show during an upload? Is any system related task
> out of whack? Could you try to get a readprofile or an oprofile
> output from the kernel, so that we can see what is slowing it down
> so much? It could be something networking related in v2.6.22-rc2.

There is a driver specific problem that's been around for a while,
but it only effects 3c59x chips, is that what you have?
