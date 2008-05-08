Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYEHJBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYEHJBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYEHJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:01:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55188
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbYEHJBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:01:31 -0400
Date: Thu, 08 May 2008 02:01:24 -0700 (PDT)
Message-Id: <20080508.020124.232275605.davem@davemloft.net>
To: hinko.kocevar@cetrtapot.si
Cc: linux-kernel@vger.kernel.org
Subject: Re: time stamped printks
From: David Miller <davem@davemloft.net>
In-Reply-To: <4822B919.5070707@cetrtapot.si>
References: <4822B919.5070707@cetrtapot.si>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m48927EB025686

From: Hinko KoÄevar <hinko.kocevar@cetrtapot.si>
Date: Thu, 08 May 2008 10:26:01 +0200

> Hi all,
> 
> I'm building latest GIT tree kernel for CRIS architecture. Right now I'm seeing 
> some strange values with printk stamps - at the start they are initialized to 0, 
> but quickly change to 42949372 - 0x028F5AFC.
> 
> Any thoughts to where to look for fix?

Very early in the boot, the timestamp counter fetching infrastructure
isn't setup yet.  So zero is reported for the timestamp.

So early on in the boot, it is often not even possible to setup
such things yet.  Because infrastructure they need for probing
etc. isn't even available yet.

This happens on basically every single Linux platform, there
isn't really anything to fix.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
