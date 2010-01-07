Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473Ab0AGHyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0AGHyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393Ab0AGHyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:54:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52477 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab0AGHyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:54:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 16:51:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
Message-Id: <20100107165117.dca1dc52.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107074812.GA16656@andrew.cmu.edu>
References: <20091231051050.GA714@andrew.cmu.edu>
	<20100106160414.bd555474.akpm@linux-foundation.org>
	<20100107012606.GA25577@andrew.cmu.edu>
	<20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
	<4B45824B.9030108@cn.fujitsu.com>
	<20100107161627.34b31e0c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107074812.GA16656@andrew.cmu.edu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 02:48:12 -0500
Ben Blum <bblum@andrew.cmu.edu> wrote:

> >  2. Making this to be reasonable value.
> > #define CGROUP_SUBSYS_COUNT (BITS_PER_BYTE*sizeof(unsigned long))
> >    I can't find why.
> 
> "We limit to this many since cgroupfs_root has subsys_bits to keep track
> of all of them." should it be less, perhaps?

It's ok if it's clear that
"this decistion is done by implementation choice, not by cgroup's nature"

> the memory footprint is not
> great, it is true, but implementing dynamically sized subsystem tracking
> data structures requires much cleverer code in many places.
> 
yes. I don't request that.

> >  3. show whehter a subsys is a loadable module or not via /proc/cgroups
> 
> with just "y" or "n"? possible, and probably easy. do note that since
> they are sorted by subsys_id, all the ones above a certain line will be
> "n" and all below will be "y".
> 
yes. 

#subsys_name    hierarchy       num_cgroups     enabled  module
cpuset  0       1       1	0

and 0/1 to show y/n ? (but this cause interface incompatibility...)


Thanks,
-Kame
   

