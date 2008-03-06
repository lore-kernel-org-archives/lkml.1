Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYCFW5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYCFW5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYCFW5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:57:00 -0500
Received: from relay1.sgi.com ([192.48.171.29]:32817 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753932AbYCFW47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:56:59 -0500
Date: Thu, 6 Mar 2008 14:56:42 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       dada1@cosmosbay.com
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080306025758.GB27150@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803061453360.16212@schroedinger.engr.sgi.com>
References: <20080303201701.GF8974@wotan.suse.de>
 <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <20080305000637.GA1510@wotan.suse.de> <20080304.161003.129716254.davem@davemloft.net>
 <Pine.LNX.4.64.0803051257030.30742@schroedinger.engr.sgi.com>
 <20080306025758.GB27150@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Nick Piggin wrote:

> There looks like definitely some networking slabs that pass the flag
> and can be non-power-of-2. And don't forget cachelines can be anywhere
> up to 256 bytes in size. So yeah it definitely makes sense to merge
> the patch and then examine the callers if you feel strongly about it.

Just do not like to add fluff that has basically no effect. I just tried 
to improve things by not doing anything special if we cannot cacheline 
align object. Least surprise (at least for me). It is bad enough that we 
just decide to ignore the request for alignment for small caches.




