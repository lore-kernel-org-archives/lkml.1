Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbYEAWDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbYEAWDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbYEAWDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:03:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYEAWDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:03:44 -0400
Date: Thu, 1 May 2008 18:03:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       Latchesar Ionkov <lucho@ionkov.net>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: [PATCH] fix flags length in net 9p
Message-ID: <20080501220341.GA31475@infradead.org>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 05:08:05PM -0400, Steven Rostedt wrote:
> 
> Some files in the net/9p directory uses "int" for flags. This can
> cause hard to find bugs on some architectures. This patch converts the
> flags to use "long" instead.
> 
> This bug was discovered by doing an allyesconfig make on the -rt kernel
> where checks are done to ensure all flags are of size sizeof(long).

We had checks like that in mainline aswell that caught a lot of errors
like this one.  Probably got lost in one of the gazillions of spinlock
rewrites..

