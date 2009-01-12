Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZALK2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZALK2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZALK2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:28:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbZALK2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:28:14 -0500
Date: Mon, 12 Jan 2009 02:21:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Kernel memory leak detector
Message-Id: <20090112022138.bd2e6ce4.akpm@linux-foundation.org>
In-Reply-To: <1231753866.10982.11.camel@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	<20090108144538.e5195575.akpm@linux-foundation.org>
	<1231753866.10982.11.camel@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 09:51:06 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:

> Hi Andrew,
> 
> On Thu, 2009-01-08 at 14:45 -0800, Andrew Morton wrote:
> > On Fri, 19 Dec 2008 18:12:56 +0000
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > A new kmemleak version is available.
> > 
> > Sorry, I'll drop this.  The level of code churn in linux-next (during
> > the merge window!) means that I've basically lost confidence that my
> > lameass fixed-up code will still even work.
> 
> OK. I noticed some minor conflicts with 2.6.29-rc1 but I'll have a look
> at linux-next as well. IIRC, is the -mm tree based on top of linux-next?

It actually includes linux-next and Linus's tree.  -mm is based on the
last-released kernel version (2.6.28, 2.6.29-rc1, etc) and includes
origin.patch (takes it up to current Linus) and linux-next.patch (takes
it up to current linux-next).

> > > git://linux-arm.org/linux-2.6.git kmemleak
> > 
> > It might be better to add that to linux-next.  If we want to merge
> > kmemleak.
> 
> I would feel a bit more comfortable if kmemleak lived for (at least) a
> release cycle in the -mm tree so that it may get wider testing. As I
> said, I mainly tested it on ARM.
> 
> If you are OK with this, I'll update the branch and make sure there are
> as few conflicts as possible (the alternative is patches by e-mail and
> based on top of linux-next).

The many trees in linux-next are actually based on current mainline. 
So if you can prepare and maintain a tree based on current mainline,
Stephen could integrate that into linux-next, hopefully.

