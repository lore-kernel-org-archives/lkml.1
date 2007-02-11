Return-Path: <linux-kernel-owner+w=401wt.eu-S1750758AbXBKRzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750758AbXBKRzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXBKRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:55:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40503
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbXBKRzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:55:54 -0500
Date: Sun, 11 Feb 2007 09:55:52 -0800 (PST)
Message-Id: <20070211.095552.71093127.davem@davemloft.net>
To: olaf@aepfle.de
Cc: rol@witbe.net, akpm@osdl.org, linux-kernel@vger.kernel.org, rol@as2917.net
Subject: Re: [PATCH] keep track of network interface renaming
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070211125423.GA30668@aepfle.de>
References: <011001c74dcf$c60c1c80$2101a8c0@donald>
	<20070211125423.GA30668@aepfle.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>
Date: Sun, 11 Feb 2007 13:54:23 +0100

> Keep track about which network interface names were renamed after the
> network device driver printed its banner.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

This is kernel log clutter.

You can ask the kernel for the list of interfaces, and
use even ethtool to ask what driver each interface is
associated with.

The patch wasn't applied because it really is not necessary.
