Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYJGIi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYJGIi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 04:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYJGIir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 04:38:47 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:36790 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYJGIir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 04:38:47 -0400
Date: Tue, 7 Oct 2008 12:37:51 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Corey Minyard <minyard@acm.org>
Cc: David Miller <davem@davemloft.net>, dada1@cosmosbay.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
Message-ID: <20081007083750.GB17079@2ka.mipt.ru>
References: <20081006185026.GA10383@minyard.local> <48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net> <48EA9A59.1090306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EA9A59.1090306@acm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 06:08:09PM -0500, Corey Minyard (minyard@acm.org) wrote:
> Would using SLAB_DESTROY_BY_RCU be ok, or would that be too expensive?

I tested skb destruction via RCU path, and got 2.5 times worse numbers
with small-packets-bulk-transfer workload.

For more details
http://tservice.net.ru/~s0mbre/blog/devel/networking/2006_12_05_1.html

-- 
	Evgeniy Polyakov
