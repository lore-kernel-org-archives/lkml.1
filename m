Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbXDMPfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbXDMPfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXDMPfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:35:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbXDMPfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:35:11 -0400
Message-ID: <461FA2EE.5090103@zytor.com>
Date: Fri, 13 Apr 2007 08:34:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: Andi Kleen <andi@firstfloor.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] i386 - pte update optimizations
References: <C2452891.D417%keir@xensource.com>
In-Reply-To: <C2452891.D417%keir@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> On 13/4/07 13:27, "Andi Kleen" <andi@firstfloor.org> wrote:
> 
>>> LOCKed instruction suck really badly on the netburst microarchitecture (like
>>> factor of 10x, or not far off). I think it's probably because of their side
>>> effect of serialising memory accesses, causing horrible pipeline stalls.
>> Unfortunately they tend to be HyperThreaded usually (except for early ones
>> and Celerons) and need the LOCK anyways.
> 
> Fair point, although quite a few people disable HT.

Note we're talking a UP-only hack.

	-hpa
