Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbZBLWRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbZBLWRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbZBLWRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:17:38 -0500
Received: from mail.fieldses.org ([141.211.133.115]:52620 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbZBLWRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:17:38 -0500
Date: Thu, 12 Feb 2009 17:17:37 -0500
To: NeilBrown <neilb@suse.de>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfs: replace uses of __constant_{endian}
Message-ID: <20090212221737.GO23593@fieldses.org>
References: <1234401418.5566.19.camel@brick> <2540bee2375afb6f08eb92d19e7a1bf0.squirrel@neil.brown.name> <1234407151.5566.21.camel@brick> <6f6ef82b3d3f7eb8445e2e40ce3b534d.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f6ef82b3d3f7eb8445e2e40ce3b534d.squirrel@neil.brown.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 02:15:06PM +1100, NeilBrown wrote:
> On Thu, February 12, 2009 1:52 pm, Harvey Harrison wrote:
> > On Thu, 2009-02-12 at 13:50 +1100, NeilBrown wrote:
> >> On Thu, February 12, 2009 12:16 pm, Harvey Harrison wrote:
> >> > The base versions handle constant folding now, none of these headers
> >> > are exported to userspace, so the __ prefixed versions are not
> >> > necessary.
> >>
> >> I assume you compile tested this?
> >>
> >> I seem to recall that the reason we did it that way was that
> >> some of the error codes are used in switch statements, and
> >> the value for a 'case:' really has to look like a constant, not just
> >> happen to evaluate to one.
> >
> > Yes, this requirement was explicitly built-in.  See how the various
> > __swabXX bits are done in linux/swab.h.
> 
> Cool, thanks!

Thanks, applied.--b.
