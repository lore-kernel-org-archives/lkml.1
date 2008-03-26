Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbYCZQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbYCZQa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYCZQaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:30:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41076 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbYCZQaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:30:15 -0400
Date: Wed, 26 Mar 2008 09:28:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Yeisley <dan.yeisley@unisys.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       mel@csn.ul.ie, olaf@aepfle.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix cache_cache bootstrap in kmem_cache_init()
In-Reply-To: <1206535048.7468.4.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803260927470.27909@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803252357330.4422@sbz-30.cs.Helsinki.FI> 
 <Pine.LNX.4.64.0803252023530.20780@schroedinger.engr.sgi.com> 
 <47E9EB77.9060909@cs.helsinki.fi> <1206535048.7468.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Daniel Yeisley wrote:

> The only way I could get the ES7000 to boot with 2.6.24.x was with
> memoryless nodes (or numa=off).  The list corruption I saw was due to
> CPU 0 not being on node 0.  

What is the ES7000?

> I do see problems with memoryless nodes on 2.6.25-rc.  I'll post a patch
> for that shortly.

Another patch in addition to the one we are discussing? Or another 
revision of the patch?

