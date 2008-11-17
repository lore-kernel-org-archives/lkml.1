Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYKQVBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYKQVBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQVBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:01:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49477
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbYKQVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:01:37 -0500
Date: Mon, 17 Nov 2008 13:01:36 -0800 (PST)
Message-Id: <20081117.130136.52188937.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: skb_release_head_state(): Re: [Bug #11308] tbench regression
 on each kernel release from 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117205530.GE12020@elte.hu>
References: <20081117182320.GA26844@elte.hu>
	<20081117184951.GA5585@elte.hu>
	<20081117205530.GE12020@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Nov 2008 21:55:30 +0100

> and ouch does that global dec on &nf_bridge->use hurt!

nf_bridge should always be NULL on your system
