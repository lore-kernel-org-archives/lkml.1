Return-Path: <linux-kernel-owner+w=401wt.eu-S1765354AbXKPWZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765354AbXKPWZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbXKPWZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:25:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56193 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082AbXKPWZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:25:27 -0500
Date: Fri, 16 Nov 2007 14:25:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PERCPU : __percpu_alloc_mask() can dynamically size
 percpu_data storage
In-Reply-To: <473E168A.9060305@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711161424540.6758@schroedinger.engr.sgi.com>
References: <473E168A.9060305@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Eric Dumazet wrote:

> Instead of allocating a fix sized array of NR_CPUS pointers for percpu_data,
> we can use nr_cpu_ids, which is generally < NR_CPUS.

Yes we can. Could you either use [] or [0] instead of the index there? 
Somehow the patch vanished when I replied to it.
