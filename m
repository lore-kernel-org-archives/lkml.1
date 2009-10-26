Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZJZCoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZJZCoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 22:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZJZCoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:44:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:58857 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbZJZCoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:44:37 -0400
Date: Mon, 26 Oct 2009 10:44:39 +0800
From: Franko Fang <huananhu@huawei.com>
Subject: Re: PATCH 23/10]Optimize the upload speed for PPP connection.
To: David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       greg@kroah.com, haegar@sdinet.de
Message-id: <001401ca55e6$435c1e30$76900b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <fae097f21b27.1b27fae097f2@huawei.com> <4AE19780.3020507@gmail.com>
 <20091024.064603.249036129.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks your advice.

But generally, PAGE_SIZE is 4096, whether it is too large or not?

If PAGE_SIZE is really appropriate, then I can resubmit the patch.

Thanks very much.
----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <william.allen.simpson@gmail.com>
Cc: <huananhu@huawei.com>; <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; <greg@kroah.com>; <haegar@sdinet.de>
Sent: Saturday, October 24, 2009 9:46 PM
Subject: Re: PATCH 23/10]Optimize the upload speed for PPP connection.


> From: William Allen Simpson <william.allen.simpson@gmail.com>
> Date: Fri, 23 Oct 2009 07:46:08 -0400
> 
>> Concur.  I'd go further than that, my code usually made room for at
>> least
>> a full MTU (MRU) with HDLC escaping.  To minimize context switches,
>> that
>> should be 3014 ((1500 MRU + 2 FCS + 4 header) * 2 escapes + 2 flags).
>> 
>> Even in the old days, when memory was tight, context switches and
>> interrupt
>> time were more expensive, too.  PPP is supposed to scale to OC-192.
> 
> Actually I'd like to see ->obuf allocated externally and then
> make it simply PAGE_SIZE.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
