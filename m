Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbZAZFWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbZAZFWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 00:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZAZFWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 00:22:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52139
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbZAZFWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 00:22:01 -0500
Date: Sun, 25 Jan 2009 21:22:03 -0800 (PST)
Message-Id: <20090125.212203.15909648.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: zbr@ioremap.net, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v3] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090122090442.GB11139@ff.dom.local>
References: <20090120110144.GB17004@ff.dom.local>
	<20090120.091616.224452074.davem@davemloft.net>
	<20090122090442.GB11139@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 22 Jan 2009 09:04:42 +0000

> It seems this sk_sndmsg_page usage (refcounting) isn't consistent.
> I used here tcp_sndmsg() way, but I think I'll go back to this question
> soon.

Indeed, it is something to look into, as well as locking.

I'll try to find some time for this, thanks Jarek.
