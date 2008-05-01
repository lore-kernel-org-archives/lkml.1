Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYEAGkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYEAGkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYEAGkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:40:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbYEAGkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:40:09 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.26-rc0
Date: Thu, 1 May 2008 02:39:47 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200804301420.11696.lenb@kernel.org> <alpine.LFD.1.10.0804301153100.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301153100.2980@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010239.48789.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008, Linus Torvalds wrote:
> 
> On Wed, 30 Apr 2008, Len Brown wrote:
> > 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> Ok, this clashed in some nasty ways in drivers/acpi/video.c due to the 
> non-racy /proc file creation changes that came through Andrew. I fixed up 
> the result, and it *looks* sane (and compiles), but I didn't actually test 
> it, and I don't know the code well. Can you double-check.

Thanks for merging video.c
When I did my builds, andrew had not yet scribbled on video.c.
I usually do a "last minute" pull to make sure you are not faced
with any merges, but this time when I did I got some version of your
tree that wouldn't build so I figured it was still moving and didn't
bother merging with it.

Anyway, I looked over this file and the things I looked for seemed okay,
but to be sure I'll repeat your merge tomorrow and see if I come
up with the same thing.

> There were some (smaller) rejects in drivers/misc/intel_menlow.c due to 
> two different versions of the same patch from Julia Lawall (again, the 
> other came through Andrew), and I picked the one from Andrew because it 
> had the later date. But again, you should double-check.

You picked the right one.
Indeed, it looks like the other files touched in Julia's earlier
patch (9030062f3d61f87c1e787b3aa134fa3a8e4b2d25)
don't handle the failure case quite right --
Rui and I will follow-up.

thanks,
-Len

