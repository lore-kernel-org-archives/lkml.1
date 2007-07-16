Return-Path: <linux-kernel-owner+w=401wt.eu-S1765753AbXGPWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765753AbXGPWcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXGPWcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:32:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbXGPWcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:32:31 -0400
Date: Mon, 16 Jul 2007 15:31:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH] stacked ifs (was Re: [PATCH 02/12] handle multiple
 network paths to AoE device)
Message-Id: <20070716153155.8a63c15d.akpm@linux-foundation.org>
In-Reply-To: <20070716221744.GM18477@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
	<60bd316bfa72fb225cefad39569999e583f4f72e.1182883861.git.ecashin@coraid.com>
	<20070702212949.5a1a1a31.akpm@linux-foundation.org>
	<20070716221744.GM18477@coraid.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 18:17:44 -0400
"Ed L. Cashin" <ecashin@coraid.com> wrote:

> > ugh.  Do this:
> > 
> > 	do {
> > 		if (t == d->htgt)
> > 			continue;
> > 		if (!(*t)->ifp->nd)
> > 			continue;
> > 		if ((*t)->nout >= (*t)->maxout)
> > 			continue;
> > 			
> > 		<stuff>
> > 	} while (++t ...)
> 
> Do you think the "stacked ifs" in the first version above could be
> accepted as a convenient extension to the K&R-based conventions in
> Documentation/CodingStyle?

Maybe.  I don't recall seeing any kernel code which uses that convention:
everyone uses &&.  So personally I'd prefer to see kernel code stick to the
one convention, given that there is not, afacit, any significant advantage
to the alternative one.
