Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXCEJMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXCEJMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 04:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXCEJMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 04:12:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42652
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbXCEJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 04:12:22 -0500
Date: Mon, 05 Mar 2007 01:12:20 -0800 (PST)
Message-Id: <20070305.011220.112620254.davem@davemloft.net>
To: lorenzo.milesi@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <29c147bd0703050052x7c8dca4esfc51b66c67b01cb1@mail.gmail.com>
References: <29c147bd0703050032k71a06603p89d541071be5d656@mail.gmail.com>
	<20070305.004436.41635733.davem@davemloft.net>
	<29c147bd0703050052x7c8dca4esfc51b66c67b01cb1@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lorenzo Milesi" <lorenzo.milesi@gmail.com>
Date: Mon, 5 Mar 2007 09:52:34 +0100

> That patch applies "fine" to 2.6.20.1:
> 
> linux-2.6.20.1 # patch -p1 --dry-run < /home/maxxer/kerpatch.txt
> patching file net/ipv6/ndisc.c
> Hunk #2 succeeded at 559 (offset 2 lines).
> Hunk #3 succeeded at 638 (offset 4 lines).
> Hunk #4 succeeded at 1390 (offset 7 lines).
> 
> If this is not the correct fix for that bug I have some other problem,
> because this seems to have fixed for me! ;)

It just means there is a miscalculation somewhere else,
because the bug that patch was meant to fix was cured
by a different fix.
