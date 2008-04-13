Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYDMADp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYDMADp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 20:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYDMADe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 20:03:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798AbYDMADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 20:03:34 -0400
Date: Sat, 12 Apr 2008 17:03:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080412170304.54f139e2.akpm@linux-foundation.org>
In-Reply-To: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 18:58:34 -0400 Bob Copeland <me@bobcopeland.com> wrote:

> (Andrew, perhaps this could bake in -mm for a cycle or two if 
> there are no objections?)

Sure, if it compiles I can stick in in there for some airtime.

> These patches 1-7 add the Optimized MPEG Filesystem, a proprietary
> filesystem used by the embedded devices Rio Karma and ReplayTV 
> which are no longer manufactured.

Adding a new FS to Linux is a pretty major thing.

- A key question (which you don't seem to have addressed at all!) is: why
  is this a useful addition to Linux?  What are the filesystem's strengths?
  What is its application?  How does it improves Linux and by how much?

  I'll go aehad and assume that its sweet-spot is streaming media files
  (perhaps more than one at a time?).  If so, then comparative performance
  measurements would be the key piece of information which we'll need when
  making a merge decision.  Probably against ext3, ext4 and XFS.

- What are the filesystem's features?  Does it journal changes, or is it
  inherently crash-safe?  Or is fsck-style repair needed?

- We'd like to see some documentation:

  - Mount options

  - Location of userspace support tools such as mkfs and fsck

  - Documentation for those tools

- A MAINTAINERS record, please?


If I include this in -mm, some kind people will try it out.  It would be
most helpful for the changelog (or even the Kconfig help) to include
sufficient information for people to be able to create, mount and check an
OMFS partition.

> I've been maintaining this reverse-engineered filesystem
> out-of-tree since around 2.6.12.

Who did the reverse-engineering, and how was it done?

Please make us confident that we won't get our butts sued off or something.
