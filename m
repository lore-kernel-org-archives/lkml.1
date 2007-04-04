Return-Path: <linux-kernel-owner+w=401wt.eu-S966262AbXDDBu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966262AbXDDBu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966269AbXDDBu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:50:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50185
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966262AbXDDBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:50:26 -0400
Date: Tue, 03 Apr 2007 18:50:26 -0700 (PDT)
Message-Id: <20070403.185026.26966290.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: david.lang@digitalinsight.com, dwmw2@infradead.org, flar@allandria.com,
       paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070404024400.56d016e1@the-village.bc.nu>
References: <20070404022828.5c9b97f3@the-village.bc.nu>
	<Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
	<20070404024400.56d016e1@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 4 Apr 2007 02:44:00 +0100

> Well the better designed serial setups on Linux use numbering so that you
> can look on the multiplexor boxes and know straight away what the
> correlation between port number and name is. In the same was as "S0 is
> console 1" is nice to have its also nice to have "mux 1 port 4" easily
> calculable not think

If you want hierarchy, create it:

/sys/blah/serial/controllerX/portY

and keeping them all under the ttyS? major keeps the simple
cases working sanely too.
