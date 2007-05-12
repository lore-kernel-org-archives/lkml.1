Return-Path: <linux-kernel-owner+w=401wt.eu-S934101AbXELAW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbXELAW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759834AbXELAWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:22:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48695 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755741AbXELAWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:22:19 -0400
Date: Fri, 11 May 2007 17:22:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [patch 1/2] From: Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20070511113915.267bcc66.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705111721250.27616@schroedinger.engr.sgi.com>
References: <20070511165749.026947116@sgi.com> <20070511165945.913632068@sgi.com>
 <20070511113915.267bcc66.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Andrew Morton wrote:

> However I think we've done enough slab work for 2.6.22 now so I'm inclined
> to queue these changes for 2.6.23.  That would mean that the slab changes in
> -mm have a dependency on the sh git tree which I am sure to forget about.
> If I end up merging these changes before Paul merges his tree, sh will
> break.  Presumably Paul will notice this ;)

Ok. Only mm is fine for what I have planned. I want to add a 
kmem_cache_ops structure for 2.6.23. Maybe I can use the now useless dtor 
field of kmem_cache_create for this?
