Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbXHJIRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbXHJIRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbXHJIQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:16:50 -0400
Received: from mail.xandmail.com ([212.155.184.97]:35752 "EHLO
	mail.xandmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbXHJIQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:16:47 -0400
Date: Fri, 10 Aug 2007 10:15:53 +0200
Message-Id: <JMJTMH$F1699B57C9B0E170ED337488612E649B@xandmail.com>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after 
	random time
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>
To: "jarkao2" <jarkao2@o2.pl>
Cc: "marcin\.slusarz" <marcin.slusarz@gmail.com>, "mingo" <mingo@elte.hu>,
       "tglx" <tglx@linutronix.de>, "torvalds" <torvalds@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "shemminger" <shemminger@linux-foundation.org>,
       "linux-net" <linux-net@vger.kernel.org>,
       "netdev" <netdev@vger.kernel.org>, "akpm" <akpm@linux-foundation.org>,
       "alan" <alan@lxorguk.ukuu.org.uk>
X-XaM3-API-Version: 4.2(R3) (B21)
X-type: 0
X-SenderIP: 212.155.184.109
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So, we still have to wait for the exact explanation...
> 
> Thanks very much Marcin!
> 
> I think, there is this one possible for your testing yet?:
> Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
> Date: Wed, 8 Aug 2007 13:00:37 +0200
> 
> If it's not a great problem it would be interesting to try this with
> different CONFIG_HZ too e.g. you could start with 100 (I guess, you
> tested very similar thing in 2.6.23-rc2 with 1000(?) already).
> 
> Jean-Baptiste: you can skip/break testing of this 'experimental'

ok

I was still testing on -rc2:
Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
Date: Wed, 8 Aug 2007 13:00:37 +0200

For me after 1day 20hours, the network is still up, with more than 1To 
of network traffic. HZ was 1000, i restart with HZ=100.

Jb


