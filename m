Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZIYWYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZIYWYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZIYWYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:24:11 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:16194 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZIYWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:24:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH net-next-2.6] cxgb3: Added private MAC address and provisioning packet handler for iSCSI
Date: Fri, 25 Sep 2009 15:30:00 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334066E7015@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH net-next-2.6] cxgb3: Added private MAC address and provisioning packet handler for iSCSI
Thread-Index: Aco+IPpatBW3FEGVRbekucaovncU1QADjDqA
References: <200909250133.n8P1XAZb030062@localhost.localdomain><20090925.121242.184886085.davem@davemloft.net> <20090925.134239.193728924.davem@davemloft.net>
From: "Karen Xie" <kxie@chelsio.com>
To: "David Miller" <davem@davemloft.net>
Cc: "Steve Wise" <swise@opengridcomputing.com>,
       "Divy Le Ray" <divy@chelsio.com>, "Rakesh Ranjan" <rakesh@chelsio.com>,
       <James.Bottomley@HansenPartnership.com>, <michaelc@cs.wisc.edu>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n8PMP216016852

Hi, Dave,

We are extremely sorry.

There is a 2nd patch that is going to the scsi git tree, which address the compilation issues you encountered.

I've re-submitted both patches as a series, so it could be applied together.

Thanks a lot,
Karen


-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Friday, September 25, 2009 1:43 PM
To: Karen Xie
Cc: Steve Wise; Divy Le Ray; Rakesh Ranjan; James.Bottomley@HansenPartnership.com; michaelc@cs.wisc.edu; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] cxgb3: Added private MAC address and provisioning packet handler for iSCSI

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
