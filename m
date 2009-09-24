Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZIXWvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZIXWvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZIXWvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:51:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49668
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbZIXWvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:51:03 -0400
Date: Thu, 24 Sep 2009 15:51:22 -0700 (PDT)
Message-Id: <20090924.155122.170781221.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@elte.hu, hpa@zytor.com
Subject: Re: [PATCH 2/3] sparc64: implement page mapping percpu first chunk
 allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ABB6C80.20109@kernel.org>
References: <4ABB6C3A.8070109@kernel.org>
	<4ABB6C80.20109@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 24 Sep 2009 21:56:32 +0900

> Implement page mapping percpu first chunk allocator as a fallback to
> the embedding allocator.  The next patch will make the embedding
> allocator check distances between units to determine whether it fits
> within the vmalloc area so that this fallback can be used on such
> cases.
> 
> sparc64 currently has relatively small vmalloc area which makes it
> impossible to create any dynamic chunks on certain configurations
> leading to percpu allocation failures.  This and the next patch should
> allow those configurations to keep working until proper solution is
> found.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> David, can you please ack this after reviewing?

This looks fine to me:

Acked-by: David S. Miller <davem@davemloft.net>
