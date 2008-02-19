Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYBSLWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYBSLWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYBSLWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:22:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbYBSLWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:22:06 -0500
Date: Tue, 19 Feb 2008 12:21:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of
	parent
Message-ID: <20080219112146.GC7204@elte.hu>
References: <200802190311.44404.yinghai.lu@sun.com> <200802190320.58561.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802190320.58561.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

>  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
>  		unsigned int length, gfp_t gfp_mask)
>  {
> -	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> +	int node = dev_to_node(&dev->dev);

i think this is a fix for the networking folks. (Dave Cc:-ed)

	Ingo
