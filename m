Return-Path: <linux-kernel-owner+w=401wt.eu-S1750910AbXBCR7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbXBCR7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 12:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXBCR7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 12:59:38 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:47953 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750907AbXBCR7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 12:59:37 -0500
Date: Sat, 3 Feb 2007 09:59:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: "Martin J. Bligh" <mbligh@mbligh.org>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <45C4ABDF.9050701@mbligh.org>
Message-ID: <Pine.LNX.4.64.0702030956400.5388@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
 <20070203101628.GB28806@infradead.org> <45C4ABDF.9050701@mbligh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Martin J. Bligh wrote:

> Doesn't matter - you can just do it lazily. If you find a page that is
> locked, move it to the locked list. when unlocking a page you *always*
> move it back to the normal list. If someone else is still locking it,
> we'll move it back to the lock list on next reclaim pass.

Sounds similar to what Andrew is proposing.
 
> I have a half-finished patch from 6 months ago that does this, but never
> found time to complete it ;-(

Could I see that patch? Could have some good approaches in there that 
would be useful.

