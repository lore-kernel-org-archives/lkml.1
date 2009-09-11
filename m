Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZIKBYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZIKBYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZIKBYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:24:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbZIKBYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:24:19 -0400
Date: Thu, 10 Sep 2009 18:22:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 1/3] agp/intel: remove restore in resume
Message-Id: <20090910182257.91c66541.akpm@linux-foundation.org>
In-Reply-To: <20090911010342.GA6819@zhen-devel.sh.intel.com>
References: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
	<20090910134252.5fc54ce2.akpm@linux-foundation.org>
	<20090911010342.GA6819@zhen-devel.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 09:03:42 +0800 Zhenyu Wang <zhenyuw@linux.intel.com> wrote:

> On 2009.09.10 13:42:52 -0700, Andrew Morton wrote:
> > On Fri,  4 Sep 2009 09:43:34 +0800
> > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> > 
> > > As early pci resume has already restored config for host
> > > bridge and graphics device, don't need to restore it again,
> > > which might cause problem on some chips, like 845G tested by
> > > Alan Stern.
> > > 
> > > Cc: Stable Team <stable@kernel.org>
> > > Cc: Alan Stern <stern@rowland.harvard.edu>
> > > Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > 
> > Why were these patches cc'ed to stable@kernel.org?  There's nothing in
> > the changelog which explains why the problem which is being fixed is
> > sufficiently serious to warrant backporting the patch.
> 
> Sorry, Andrew. I wasn't awared that an earlier version of this patch
> has already been merged, and this patch fixed resume issue on Alan's
> 845G, which was discussed on linux-pm list, I should have made more
> clear note about that. We've also seen other resume failure bugs, which
> might be relate to this one. So I think it should be fine for stable.

We still don't have a changelog for this patch which explains to the
-stable maintainers (and those who follow -stable commits):

a) what bug this patch fixes and

b) why they should merge it - this should be ovbious if a) is provided.

this isn't pointless paperwork - it matters to those who maintain and
use the -stable tree.  Vague references to traffic on the linux-pm list
aren't at all useful.

>From my reading of the above, it appears that Alan was experiencing
<secretbug> and this patch was tested and fixed it, yes?

> > 
> > Was there a [patch 3/3]?  I didn't receive it.
> 
> sorry, my mistake, the 3/3 commit on my tree is not ready to send, 
> forget to make git format-patch happy.

OK.
