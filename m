Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYJGU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYJGU4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYJGU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:56:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56504
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbYJGU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:56:12 -0400
Date: Tue, 07 Oct 2008 13:55:48 -0700 (PDT)
Message-Id: <20081007.135548.56141000.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: dada1@cosmosbay.com, benny+usenet@amorsen.dk, minyard@acm.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081007160729.60c076c4@speedy>
References: <m37i8k3hv1.fsf@ursa.amorsen.dk>
	<48EB5D28.7000503@cosmosbay.com>
	<20081007160729.60c076c4@speedy>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 7 Oct 2008 16:07:29 +0200

> The idea of keeping chains short is the problem. That code should
> just be pulled because it doesn't help that much, and also creates
> bias on the port randomization.

I have that patch from Vitaly Mayatskikh which does exactly this.

I keep looking at it, but I can't bring myself to apply it since
I'm not completely convinced.
