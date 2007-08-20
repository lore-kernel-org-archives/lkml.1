Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbXHTIGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbXHTIGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXHTIGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:06:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45163
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbXHTIGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:06:23 -0400
Date: Mon, 20 Aug 2007 01:06:22 -0700 (PDT)
Message-Id: <20070820.010622.41634915.davem@davemloft.net>
To: mad@automagically.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: possible endless loop in PROM initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070820075949.GA5927@vimes.madsworld.lan>
References: <20070820075949.GA5927@vimes.madsworld.lan>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Dahms <mad@automagically.de>
Date: Mon, 20 Aug 2007 09:59:49 +0200

> I could track down the issue to the function __prom_nextprop() in
> arch/sparc/prom/tree.c, but I am now looking for the definition of
> prom_nodeops->no_nextprop() without success.

When we boot the firmware provides a vector of function
pointers, and this is prom_nodeops.  So prom_nodeops->no_nextprop()
is a routine inside the PROM.

