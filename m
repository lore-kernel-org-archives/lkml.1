Return-Path: <linux-kernel-owner+w=401wt.eu-S965111AbXCUV5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111AbXCUV5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965109AbXCUV5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:57:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38021 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965111AbXCUV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:57:23 -0400
Date: Wed, 21 Mar 2007 14:57:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ethan Solomita <solo@google.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <20070321145254.1c1011b9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703211454410.5130@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <46019F67.3010300@google.com> <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
 <20070321145254.1c1011b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Andrew Morton wrote:

> > The NFS patch went into Linus tree a couple of days ago
> 
> Did it fix the oom issues which you were observing?

Yes it reduced the dirty ratios to reasonable numbers in a simple copy 
operation that created large amounts of dirty pages before. The trouble is 
now to check if cpuset writeback patch still works correctly.

Probably have to turn off block device congestion checks somehow.
