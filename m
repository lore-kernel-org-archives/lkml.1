Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZKTTNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZKTTNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZKTTNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:13:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47663
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390AbZKTTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:13:38 -0500
Date: Fri, 20 Nov 2009 11:13:55 -0800 (PST)
Message-Id: <20091120.111355.141716974.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: jaswinder@kernel.org, yi.zou@intel.com, peter.p.waskiewicz.jr@intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ixgbe: move tc variable to CONFIG_IXGBE_DCB
From: David Miller <davem@davemloft.net>
In-Reply-To: <9929d2390911200624mf352c28u55a8b2aee8b52fa3@mail.gmail.com>
References: <1258725747.3562.5.camel@ht.satnam>
	<9929d2390911200624mf352c28u55a8b2aee8b52fa3@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAKJDq16021383

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 20 Nov 2009 06:24:21 -0800

> On Fri, Nov 20, 2009 at 06:02, Jaswinder Singh Rajput
> <jaswinder@kernel.org> wrote:
>>
>> tc is required by CONFIG_IXGBE_DCB.
>> This also fixes compilation warning:
>>
>> Â drivers/net/ixgbe/ixgbe_main.c: In function â€˜ixgbe_tx_is_pausedâ€™:
>> Â drivers/net/ixgbe/ixgbe_main.c:245: warning: unused variable â€˜tcâ€™
>>
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
 ...
> I just submitted a patch to fix this.  So NAK.

But his is much cleaner that your's, less ifdefs.  I think we
should therefore use Jasdinder's version.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
