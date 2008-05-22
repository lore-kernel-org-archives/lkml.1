Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYEVTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYEVTLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbYEVTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:11:16 -0400
Received: from stinky.trash.net ([213.144.137.162]:44578 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbYEVTLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:11:08 -0400
Message-ID: <4835C4E6.3050005@trash.net>
Date: Thu, 22 May 2008 21:09:26 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com, clameter@sgi.com
Subject: Re: [PATCH] netfilter: use krealloc() in nf_conntrack_extend.c V2
References: <Pine.LNX.4.64.0805222145320.6071@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805222155150.6294@sbz-30.cs.Helsinki.FI> <4835C41E.2010502@trash.net> <4835C45F.5030201@cs.helsinki.fi>
In-Reply-To: <4835C45F.5030201@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Patrick McHardy wrote:
>> Unfortunately this means we'll always have to reallocate, even
>> if there's still some room left from the previous allocation.
>> Any chance to avoid that?
>
> No, no, krealloc() avoids reallocation if there's enough room in the 
> buffer to fit newlen.

Great, thanks for the explanation. Is this patch targeted
at 2.6.26 or 2.6.27?

