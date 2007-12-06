Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXLFNz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXLFNz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 08:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXLFNzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 08:55:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54505
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbXLFNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 08:55:16 -0500
Date: Thu, 06 Dec 2007 05:55:15 -0800 (PST)
Message-Id: <20071206.055515.180308628.davem@davemloft.net>
To: stefan@loplof.de
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712061330.20586.stefan@loplof.de>
References: <200712061235.06025.stefan@loplof.de>
	<20071206.033909.76192198.davem@davemloft.net>
	<200712061330.20586.stefan@loplof.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Rompf <stefan@loplof.de>
Date: Thu, 6 Dec 2007 13:30:20 +0100

> IMHO this is what developers expect, and is also consistent with the
> fact that POSIX does not define O_NONBLOCK behaviour for local
> files.

You keep ignoring the fact that, as Herbert and I discussed, not
blocking for IPSEC resolution will make some connect() cases fail that
would otherwise not fail.

There are two sides to this issue, and we need to consider them
both.

Long term a resolution-packet-queue provides a solution that handles
both angles correctly, but we don't have that code yet.
