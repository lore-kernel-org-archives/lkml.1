Return-Path: <linux-kernel-owner+w=401wt.eu-S1763388AbYEAVUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763388AbYEAVUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYEAVT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:19:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbYEAVT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:19:57 -0400
Date: Thu, 1 May 2008 14:19:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, lucho@ionkov.net, ericvh@gmail.com
Subject: Re: [PATCH] fix flags length in net 9p
Message-Id: <20080501141919.78b7dc4f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 17:08:05 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> Some files in the net/9p directory uses "int" for flags. This can
> cause hard to find bugs on some architectures. This patch converts the
> flags to use "long" instead.

gargh.

> This bug was discovered by doing an allyesconfig make on the -rt kernel
> where checks are done to ensure all flags are of size sizeof(long).

I was about to suggest that we do something like that...

I wonder how messy it is.  I long ago lost the ability to follow the
convolutions in include/linux/spinlock*.h :(  gotta patch?

