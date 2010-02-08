Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0BHThH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:37:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab0BHThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:37:05 -0500
Date: Mon, 8 Feb 2010 14:36:58 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@parisplace.org>
Cc: Dave Chinner <david@fromorbit.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: vfs/fsnotify trees build warning
Message-ID: <20100208193658.GA9527@infradead.org>
References: <20100125150456.c796f0b0.sfr@canb.auug.org.au> <20100125042925.GM25842@discord.disaster> <7e0fb38c1002081001y111bd0a2p40a8a896b0668d13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e0fb38c1002081001y111bd0a2p40a8a896b0668d13@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 01:01:46PM -0500, Eric Paris wrote:
> On Sun, Jan 24, 2010 at 11:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Jan 25, 2010 at 03:04:56PM +1100, Stephen Rothwell wrote:
> >> Hi Eric, Al,
> >>
> >> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> I just switched fsnotify to use const unsigned char * so hopefully
> they will shut up tomorrow....

The xfs tree is also about to get a patch to turn off -Wpointer-sign
again.  If it was up to me we should turn it on for the whole build,
we'll just need good way to deal with static initializers and strlen,
but some simple wrappers might do it for those.

