Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbYEVTOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbYEVTOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYEVTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:13:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59830 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbYEVTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:13:47 -0400
Message-ID: <4835C569.5080908@cs.helsinki.fi>
Date: Thu, 22 May 2008 22:11:37 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com, clameter@sgi.com
Subject: Re: [PATCH] netfilter: use krealloc() in nf_conntrack_extend.c V2
References: <Pine.LNX.4.64.0805222145320.6071@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805222155150.6294@sbz-30.cs.Helsinki.FI> <4835C41E.2010502@trash.net> <4835C45F.5030201@cs.helsinki.fi> <4835C4E6.3050005@trash.net>
In-Reply-To: <4835C4E6.3050005@trash.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Great, thanks for the explanation. Is this patch targeted
> at 2.6.26 or 2.6.27?

I don't think we will be removing ksize() in 2.6.26 anyway so 2.6.27 is 
fine for this patch. Thanks!

		Pekka

