Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYDBIoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYDBIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYDBIo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:44:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbYDBIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:44:26 -0400
Date: Wed, 2 Apr 2008 01:43:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: kosaki.motohiro@jp.fujitsu.com, csnook@redhat.com, davej@codemonkey.org.uk,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: GFP_ATOMIC page allocation failures.
Message-Id: <20080402014317.7634515f.akpm@linux-foundation.org>
In-Reply-To: <20080402.012406.246863209.davem@davemloft.net>
References: <47F32789.2070703@redhat.com>
	<20080402005646.f8df1c1b.akpm@linux-foundation.org>
	<20080402171104.9591.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080402.012406.246863209.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 01:24:06 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 02 Apr 2008 17:17:50 +0900
> 
> > if network guys hope known-good driver should call 
> > __netdev_alloc_skb(dev, length, GFP_ATOMIC|__GFP_NOWARN) instead netdev_alloc_skb,
> > I think we should make netdev_alloc_skb_nowarn.
> 
> Giving it a proper name like this takes away the indication that this
> situation is very special.
> 
> Two leading underscores to an interface means "something special and
> unusual requiring more careful consideration than usual is occuring
> here."  netdev_alloc_skb_nowarn() on the other hand, does not
> convey this meaning.
> 
> And we will have very few drivers that use this construct, thus it
> really is best to handle things the way Andrew has.

Oh.  I just went and redid thing the other way.  Picked the same name too.

Whatever.
