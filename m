Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXLFCZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXLFCZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXLFCZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:25:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46436
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbXLFCZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:25:01 -0500
Date: Wed, 05 Dec 2007 18:25:00 -0800 (PST)
Message-Id: <20071205.182500.166603251.davem@davemloft.net>
To: stefan@loplof.de
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712051939.08384.stefan@loplof.de>
References: <20071204.223023.262159049.davem@davemloft.net>
	<20071205065132.GA11476@gondor.apana.org.au>
	<200712051939.08384.stefan@loplof.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Rompf <stefan@loplof.de>
Date: Wed, 5 Dec 2007 19:39:07 +0100

> I'd strongly suggest doing so. AFAIK, behaviour of connect() on nonblocking 
> sockets is quite well defined in POSIX.

You are entitled to your opinion.

POSIX says nothing about the semantics of route resolution.
Non-blocking doesn't mean "cannot sleep no matter what".

> If this is changed for some IP sockets, event-driven applications
> will randomly and subtly break.

If this was such a clear cut case we'd have changed things
a long time ago, but it isn't so don't pretend this is the
case.
