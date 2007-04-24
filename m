Return-Path: <linux-kernel-owner+w=401wt.eu-S1423061AbXDXTz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423061AbXDXTz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423066AbXDXTz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:55:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45576 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423061AbXDXTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:55:59 -0400
Date: Tue, 24 Apr 2007 12:55:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704241254420.12907@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <20070424101116.1cb7512e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Hugh Dickins wrote:

> Or Christoph may prevail in persuading there's no such problem.

This is pointless. NUMA allocations can only be controlled for the highest 
zone. If we switch to a lower zone then we allocate on a different zone 
than the user requested.

