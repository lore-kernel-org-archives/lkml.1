Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbXKPHhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbXKPHhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXKPHhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:37:34 -0500
Received: from waste.org ([66.93.16.53]:60826 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbXKPHhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:37:33 -0500
Date: Fri, 16 Nov 2007 01:37:17 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Rai <abhishekrai@google.com>, Andreas Dilger <adilger@sun.com>,
       linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Message-ID: <20071116073716.GB17536@waste.org>
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com> <20071115230219.1fe9338c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115230219.1fe9338c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 11:02:19PM -0800, Andrew Morton wrote:
> On Thu, 15 Nov 2007 21:02:46 -0800 "Abhishek Rai" <abhishekrai@google.com> wrote:
...
> > 3. e2fsck speedup with metaclustering varies from disk
> > to disk with most benefit coming from disks which have a large number
> > of indirect blocks. For disks which have few indirect blocks, fsck
> > usually doesn't take too long anyway and hence it's OK not to deliver
> > a huge speedup there. But in all cases, metaclustering doesn't cause
> > any degradation in IO performance as seen in the benchmarks above.
> 
> Less speedup, for more-and-smaller files, it appears.
> 
> An important question is: how does it stand up over time?  Simply laying
> files out a single time on a fresh fs is the easy case.  But what happens
> if that disk has been in continuous create/delete/truncate/append usage for
> six months?

Try Chris Mason's compilebench, which is a decent aging simulation.

-- 
Mathematics is the supreme nostalgia of our time.
