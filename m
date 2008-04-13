Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYDMD41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYDMD41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 23:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbYDMD4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 23:56:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862AbYDMD4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 23:56:16 -0400
Date: Sat, 12 Apr 2008 20:55:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
In-Reply-To: <20080413033344.GA27494@hash.localnet>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	<20080412170304.54f139e2.akpm@linux-foundation.org>
	<20080413033344.GA27494@hash.localnet>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 23:33:44 -0400 Bob Copeland <me@bobcopeland.com> wrote:

> On Sat, Apr 12, 2008 at 05:03:04PM -0700, Andrew Morton wrote:
> > Adding a new FS to Linux is a pretty major thing.
> > 
> > - A key question (which you don't seem to have addressed at all!) is: why
> >   is this a useful addition to Linux?  What are the filesystem's strengths?
> >   What is its application?  How does it improves Linux and by how much?
> 
> Honestly, I'm not sure if this FS is mainline material or not.

OIC.

>  If it is, 
> it is in the sense that the Amiga FS, befs, and so forth are useful:
> it's a dead filesystem that a very few people still have a reason to
> use.  If FUSE is where this should live, then I'll just simply focus my
> time on that instead (since I already have it in FUSE).

Yes, pursuing the FUSE implementation sounds a better approach - it avoids
burdening the kernel with a filesysstem which few will be interested in and
is more practical for use by those who _are_ interested in it.

