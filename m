Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbZJOGag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbZJOGag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZJOGaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:30:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57058
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754977AbZJOGae convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:30:34 -0400
Date: Wed, 14 Oct 2009 23:30:30 -0700 (PDT)
Message-Id: <20091014.233030.129292617.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mcetra@navynet.it, ctrixk@navynet.it, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] virtio_net: use dev_kfree_skb_any() in
 free_old_xmit_skbs()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AD66E9B.2020803@gmail.com>
References: <4AD455E4.2070105@navynet.it>
	<4AD62626.6010709@navynet.it>
	<4AD66E9B.2020803@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 15 Oct 2009 02:36:43 +0200

> Massimo Cetra a écrit :
>> Eric,
>> thanks for the patch.
>> The problem didn't arise again and i haven't seen any warning like that
>> on both servers where that problem was happening more frequently.
>> 
>> I would say that it's fixed and if it's not, i'll let you know as soon
>> as it happens again.
>> 
> 
> Thanks Massimo, I think patch is reasonably safe and should be taken as is :
> 
> 
> [PATCH] virtio_net: use dev_kfree_skb_any() in free_old_xmit_skbs()

Applied, thanks Eric.
