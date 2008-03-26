Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYCZD3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYCZD3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYCZD3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:29:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55316 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752340AbYCZD3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:29:15 -0400
Date: Tue, 25 Mar 2008 20:27:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, mel@csn.ul.ie, olaf@aepfle.de,
       dan.yeisley@unisys.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix cache_cache bootstrap in kmem_cache_init()
In-Reply-To: <Pine.LNX.4.64.0803252357330.4422@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0803252023530.20780@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803252357330.4422@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Pekka J Enberg wrote:

> Andrew/Christoph, this needs to go into 2.6.25 and probably 2.6.24.x as 
> well. Hopefully either Mel or Olaf can test this on their machines to 
> confirm the fix doesn't break their setup.

Ok. I see the problem in the amazing artwork of NUMA bootstrap in SLAB 
that was made even more complex with the fixes late in 2.6.24. 
Now we are up for the da capo on this in 2.6.25. Sigh.

Will merge if I get confirmation that this indeed addresses the issue.
