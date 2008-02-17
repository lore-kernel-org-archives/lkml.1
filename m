Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYBQFxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYBQFxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYBQFx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:53:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41486
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbYBQFx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:53:27 -0500
Date: Sat, 16 Feb 2008 21:54:01 -0800 (PST)
Message-Id: <20080216.215401.20463603.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: dada1@cosmosbay.com, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: include/linux/pcounter.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080216112618.ec450f9b.akpm@linux-foundation.org>
References: <20080216025051.751b4a86.akpm@linux-foundation.org>
	<47B6D12A.3090401@cosmosbay.com>
	<20080216112618.ec450f9b.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 16 Feb 2008 11:26:18 -0800

> On Sat, 16 Feb 2008 13:03:54 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > Yes, per connection basis. Some workloads want to open/close more than 1000 
> > sockets per second.
> 
> ie: slowpath

Definitely not slow path in the networking.

Connection rates are definitely as, or more, important than packet
rates for certain workloads.
