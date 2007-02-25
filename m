Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbXBYAwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbXBYAwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbXBYAwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:52:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41341
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932914AbXBYAwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:52:06 -0500
Date: Sat, 24 Feb 2007 16:52:03 -0800 (PST)
Message-Id: <20070224.165203.41636677.davem@davemloft.net>
To: msa@moth.iki.fi
Cc: olaf@bigred.inka.de, linux-kernel@vger.kernel.org
Subject: Re: ipv4 and ipv6 stacks for new link layers?
From: David Miller <davem@davemloft.net>
In-Reply-To: <200702241645.l1OGj3GV023299@moth.iki.fi>
References: <200702231149.l1NBnlZD029626@moth.iki.fi>
	<E1HKzK9-0001aX-TT@bigred.inka.de>
	<200702241645.l1OGj3GV023299@moth.iki.fi>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markku Savela <msa@moth.iki.fi>
Date: Sat, 24 Feb 2007 18:45:03 +0200

> I think that is worse than allow a new driver to provide a simple
> service function which maps IPv4/6 multicast address into link layer
> address, when asked.

The problem is that this mapping isn't so simple for several
link layer types.

I outlined in another email this problem, in that any interface
which would allow a driver-like-API for this would be either
overly general or so specific as to be useless.
