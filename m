Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZBDJP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZBDJP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZBDJPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:15:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36305
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbZBDJPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:15:39 -0500
Date: Wed, 04 Feb 2009 01:15:35 -0800 (PST)
Message-Id: <20090204.011535.183331841.davem@davemloft.net>
To: w@1wt.eu
Cc: herbert@gondor.apana.org.au, zbr@ioremap.net, jarkao2@gmail.com,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090204091217.GA21385@1wt.eu>
References: <20090204085907.GA19388@gondor.apana.org.au>
	<20090204.010146.18100191.davem@davemloft.net>
	<20090204091217.GA21385@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Wed, 4 Feb 2009 10:12:17 +0100

> And the arbitrary choice of 9k for jumbo frames was total crap too.
> It's clear that no hardware designer was involved in the process.

Willy, do some reasearch, this also completely wrong.

Alteon effectively created jumbo MTUs in their Acenic chips since that
was the first chip to ever do it.  Those were hardware engineers only
making those design decisions.

I think this is will I will stop taking part in this part of the
discussion.  Every posting is full of misinformation and I've got
better things to do than to refute them every 5 minutes.  :-/
