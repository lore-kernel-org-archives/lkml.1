Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZIYUmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZIYUmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZIYUmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:42:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37677
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbZIYUmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:42:20 -0400
Date: Fri, 25 Sep 2009 13:42:39 -0700 (PDT)
Message-Id: <20090925.134239.193728924.davem@davemloft.net>
To: kxie@chelsio.com
Cc: swise@opengridcomputing.com, divy@chelsio.com, rranjan@chelsio.com,
       James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] cxgb3: Added private MAC address and
 provisioning packet handler for iSCSI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090925.121242.184886085.davem@davemloft.net>
References: <200909250133.n8P1XAZb030062@localhost.localdomain>
	<20090925.121242.184886085.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n8PKgn16015917

From: David Miller <davem@davemloft.net>
Date: Fri, 25 Sep 2009 12:12:42 -0700 (PDT)

> From: kxie@chelsio.com
> Date: Thu, 24 Sep 2009 18:33:10 -0700
> 
>> 00c487ed661c0904757a21b7c958eba59e68482a
>> [PATCH net-next-2.6] cxgb3: Added private MAC address and provisioning packet handler for iSCSI
>> 
>> This patch added support of private MAC address per port and provisioning
>> packet handler for iSCSI traffic only.
>> 
>> Acked-by: Karen Xie <kxie@chelsio.com>
>> Acked-by: Divy Le Ray <divy@chelsio.com>
>> Signed-off-by: Rakesh Ranjan <rranjan@chelsio.com>
> 
> Applied, thanks.

This doesn't even build, reverting:

drivers/scsi/cxgb3i/cxgb3i_iscsi.c: In function â€˜cxgb3i_host_set_paramâ€™:
drivers/scsi/cxgb3i/cxgb3i_iscsi.c:718: error: â€˜struct port_infoâ€™ has no member named â€˜iscsi_ipv4addrâ€™
drivers/scsi/cxgb3i/cxgb3i_iscsi.c: In function â€˜cxgb3i_host_get_paramâ€™:
drivers/scsi/cxgb3i/cxgb3i_iscsi.c:755: error: â€˜struct port_infoâ€™ has no member named â€˜iscsi_ipv4addrâ€™
make[3]: *** [drivers/scsi/cxgb3i/cxgb3i_iscsi.o] Error 1
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
