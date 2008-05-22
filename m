Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYEVTJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYEVTJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYEVTJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:09:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47166 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYEVTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:09:21 -0400
Message-ID: <4835C45F.5030201@cs.helsinki.fi>
Date: Thu, 22 May 2008 22:07:11 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com, clameter@sgi.com
Subject: Re: [PATCH] netfilter: use krealloc() in nf_conntrack_extend.c V2
References: <Pine.LNX.4.64.0805222145320.6071@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805222155150.6294@sbz-30.cs.Helsinki.FI> <4835C41E.2010502@trash.net>
In-Reply-To: <4835C41E.2010502@trash.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Unfortunately this means we'll always have to reallocate, even
> if there's still some room left from the previous allocation.
> Any chance to avoid that?

No, no, krealloc() avoids reallocation if there's enough room in the 
buffer to fit newlen.
