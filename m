Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZD2Fpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZD2Fpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZD2FpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:45:19 -0400
Received: from night.yars.free.net ([193.233.48.54]:52753 "EHLO
	night.yars.free.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbZD2FpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:45:17 -0400
Date: Wed, 29 Apr 2009 09:45:10 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090429054510.GA8267@night.netis.ru>
References: <20090422055735.GA4334@night.netis.ru> <20090427054103.GA27529@night.netis.ru> <20090428125755.GA5242@night.netis.ru> <49F76BF6.4040709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F76BF6.4040709@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 10:49:58PM +0200, Jarek Poplawski wrote:
> Do you mean if you wait a bit longer (until the first one is really removed)

The problem is that it is never removed. I waited for at least 30 minutes.

> before running another one, it doesn't s(t)uck? Is there a change e.g. wrt.
> 2.6.28?

I mean, 'vconfig rem' on another interface stucks if the previous vconfig
has not finished, and it never finishes. So I cannot check if other vlan
interfaces have the same 'refcnt' problem. So far I tried 'vconfig rem' on
two vlan interfaces and I have a dozen.

Again, the problem only happens after I notice surprisingly high LA (30
instead of 2-6) and interactive slowness. When it happens, I check network
usage, disk usage, cpu usage, mem usage - they are normal or even lower than
usual.

The server is running transparent squid and named. The last kernel version
was 2.6.27.21 and it did not have this problem.

-- 
   Alexander.
