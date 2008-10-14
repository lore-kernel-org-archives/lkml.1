Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYJNBID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYJNBID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYJNBHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:07:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYJNBHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:07:49 -0400
Message-ID: <48F3F014.3050406@zytor.com>
Date: Mon, 13 Oct 2008 18:04:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <20081014005428.EC2D8DDF93@ozlabs.org>
In-Reply-To: <20081014005428.EC2D8DDF93@ozlabs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> That debug outpout in kernel/resource.c is busted on 32-bit
> machines, fix it with appropriate casts.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> One day Yinghai will figure out that resource_size_t can be 32-bit
> and thus as printk arguments must be cast to (unsigned long long)
> explicitely when using %llx... hopefully, that day, Ingo will also
> catch these before committing them as it's not the first one like
> this :-)
> 

I really think Linus' solution (add a resource printf modifier, that can 
contain the whole format) is much better.

	-hpa
