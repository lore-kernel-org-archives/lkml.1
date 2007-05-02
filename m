Return-Path: <linux-kernel-owner+w=401wt.eu-S2993031AbXEBKbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993031AbXEBKbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993034AbXEBKbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:31:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56872 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993031AbXEBKbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:31:00 -0400
Date: Wed, 2 May 2007 12:30:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070502103056.GA4392@one.firstfloor.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <1178065870.28659.96.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178065870.28659.96.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 10:31:10AM +1000, Rusty Russell wrote:
> On Tue, 2007-05-01 at 14:17 +0200, Andi Kleen wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > > Will merge the rustyvisor.
> > 
> > IMHO the user code still doesn't belong into Documentation.
> > Also it needs another review round I guess. And some beta testing by
> > more people.
> 
> Like any piece of code more review and more testing would be great.
> (Your earlier review was particularly useful!).  But it's not clear that
> waiting for longer will achieve either.

Not clear to me. Release a clear lguest patchkit with documentation
on l-k several times and you'll probably get both reviewers and testers.
Then confidence level will rise.

> 
> Look at kvm's experience for the reverse case: it went in, then got
> rewritten.

They at least already had some user base at this point.

> As for the code in Documentation, my initial attempts tried to get
> around the need for a userspace part by putting everything in the kernel
> module.  It meant you could launch a guest by writing a string
> to /dev/lguest (no real ABI burden there), but it's a worse solution
> than some user code in the kernel tree 8(

Just put it into a separate tarball.

-Andi
