Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYLDGNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYLDGNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYLDGNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:13:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47149
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYLDGNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:13:23 -0500
Date: Wed, 03 Dec 2008 22:13:23 -0800 (PST)
Message-Id: <20081203.221323.91765378.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: fix CPU unplug race in
 percpu_counter_destroy()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4936D287.6090206@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 03 Dec 2008 19:40:07 +0100

> While working on percpu_counter on net-next-2.6, I found
> a CPU unplug race in percpu_counter_destroy()
> 
> (Very unlikely of course)
> 
> Thank you
> 
> [PATCH] percpu_counter: fix CPU unplug race in percpu_counter_destroy()
> 
> We should first delete the counter from percpu_counters list
> before freeing memory, or a percpu_counter_hotcpu_callback()
> could dereference a NULL pointer.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Acked-by: David S. Miller <davem@davemloft.net>
