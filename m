Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXFZSXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXFZSXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbXFZSXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:23:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44831 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbXFZSXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:23:31 -0400
Date: Tue, 26 Jun 2007 11:23:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 21/26] Slab defragmentation: support dentry defragmentation
In-Reply-To: <20070626011845.bfd4efe0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706261122130.18010@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com> <20070618095918.404020641@sgi.com>
 <20070626011845.bfd4efe0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Andrew Morton wrote:

> > +			 * objects.
> > +			 */
> > +			abort = 1;
> 
> It's unobvious why the entire shrink effort is abandoned if one busy dentry
> is encountered.  Please flesh the comment out explaining this.

If one item is busy then we cannot reclaim the slab. So what would be the 
use of continuing efforts. I thought I put that into the description? I 
can put that into the code too.

