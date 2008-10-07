Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbYJGVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYJGVVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbYJGVVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:21:05 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47158 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbYJGVVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:21:04 -0400
Date: Tue, 7 Oct 2008 23:20:56 +0200
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, benny+usenet@amorsen.dk, minyard@acm.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
Message-ID: <20081007232056.036e26e6@speedy>
In-Reply-To: <20081007.135548.56141000.davem@davemloft.net>
References: <m37i8k3hv1.fsf@ursa.amorsen.dk>
	<48EB5D28.7000503@cosmosbay.com>
	<20081007160729.60c076c4@speedy>
	<20081007.135548.56141000.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2008 13:55:48 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Tue, 7 Oct 2008 16:07:29 +0200
> 
> > The idea of keeping chains short is the problem. That code should
> > just be pulled because it doesn't help that much, and also creates
> > bias on the port randomization.
> 
> I have that patch from Vitaly Mayatskikh which does exactly this.
> 
> I keep looking at it, but I can't bring myself to apply it since
> I'm not completely convinced.

Some one on a busy server should run it and measure the delta in hash chains.
I would, but don't run anything that has more than a few UDP's open.
