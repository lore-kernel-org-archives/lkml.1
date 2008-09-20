Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbYITP3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbYITP3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 11:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbYITP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 11:29:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:11776 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYITP30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 11:29:26 -0400
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
From: Daniel Walker <dwalker@mvista.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
In-Reply-To: <20080919.234824.223177211.davem@davemloft.net>
References: <20080919.234824.223177211.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 08:29:21 -0700
Message-Id: <1221924561.1343.121.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-19 at 23:48 -0700, David Miller wrote:
> Jens Axboe has written some hacks for the block layer that allow
> queueing softirq work to remote cpus.  In the context of the block
> layer he used this facility to trigger the softirq block I/O
> completion on the same cpu where the I/O was submitted.
> 

> Jen's, as stated, has block layer uses for this.  I intend to use this
> for receive side flow seperation on non-multiqueue network cards.  And
> Steffen Klassert has a set of IPSEC parallelization changes that can
> very likely make use of this.

What's the benefit that you (or Jens) sees from migrating softirqs from
specific cpu's to others?

Daniel

