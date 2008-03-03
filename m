Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYCCVQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYCCVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYCCVQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:16:46 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52363 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752664AbYCCVQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:16:45 -0500
Date: Mon, 3 Mar 2008 13:16:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080303201701.GF8974@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de>
 <Pine.LNX.4.64.0803031107130.6917@schroedinger.engr.sgi.com>
 <20080303200613.GC8974@wotan.suse.de> <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
 <20080303201701.GF8974@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> > HWCACHE_ALIGN means that you want the object to be aligned at 
> > cacheline boundaries for optimization. Why does crossing cacheline 
> > boundaries matter in this case?
> 
> No, HWCACHE_ALIGN means that you want the object not to cross cacheline
> boundaries for at least cache_line_size() bytes. You invented new

Interesting new definition....


