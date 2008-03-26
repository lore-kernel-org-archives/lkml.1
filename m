Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYCZM7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYCZM7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYCZM7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:59:39 -0400
Received: from usea-naimss2.unisys.com ([192.61.61.104]:4471 "EHLO
	usea-naimss2.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYCZM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:59:38 -0400
Subject: Re: [PATCH] slab: fix cache_cache bootstrap in kmem_cache_init()
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       mel@csn.ul.ie, olaf@aepfle.de, linux-kernel@vger.kernel.org
In-Reply-To: <47E9EB77.9060909@cs.helsinki.fi>
References: <Pine.LNX.4.64.0803252357330.4422@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0803252023530.20780@schroedinger.engr.sgi.com>
	 <47E9EB77.9060909@cs.helsinki.fi>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Mar 2008 08:37:28 -0400
Message-Id: <1206535048.7468.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-2.fc9) 
X-OriginalArrivalTime: 26 Mar 2008 12:55:58.0993 (UTC) FILETIME=[BCE60810:01C88F40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 08:21 +0200, Pekka Enberg wrote:
> Christoph Lameter wrote:
> > Will merge if I get confirmation that this indeed addresses the issue.
> 
> It fixes the problem reported by Daniel:
> 
> http://lkml.org/lkml/2008/3/25/249
> 
> But what I worry about is breaking setups that have memoryless nodes.
> 
> 			Pekka

The only way I could get the ES7000 to boot with 2.6.24.x was with
memoryless nodes (or numa=off).  The list corruption I saw was due to
CPU 0 not being on node 0.  
I do see problems with memoryless nodes on 2.6.25-rc.  I'll post a patch
for that shortly.

Dan
