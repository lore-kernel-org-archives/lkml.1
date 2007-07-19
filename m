Return-Path: <linux-kernel-owner+w=401wt.eu-S935890AbXGSAAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935890AbXGSAAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761754AbXGSAA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:00:29 -0400
Received: from colin.muc.de ([193.149.48.1]:2807 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760932AbXGSAA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:00:28 -0400
Date: 19 Jul 2007 02:00:26 +0200
Date: Thu, 19 Jul 2007 02:00:26 +0200
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] i386: use x86_64's desc_def.h
Message-ID: <20070719000026.GA29650@muc.de>
References: <1184743355.10380.112.camel@localhost.localdomain> <1184743422.10380.114.camel@localhost.localdomain> <469E3DA1.3010600@vmware.com> <1184801261.10380.174.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184801261.10380.174.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 09:27:41AM +1000, Rusty Russell wrote:
> On Wed, 2007-07-18 at 09:19 -0700, Zachary Amsden wrote:
> > > +#define GET_CONTENTS(desc)	(((desc)->raw32.b >> 10) & 3)
> > > +#define GET_WRITABLE(desc)	(((desc)->raw32.b >>  9) & 1)
> > 
> > You got rid of the duplicate definitions here, but then added new 
> > duplicates (GET_CONTENTS / WRITABLE).  Can you stick them in desc.h?
> 
> To be honest, I got sick of counting bits at this point, and didn't want
> to introduce bugs.

Where is 1/ and 3/ ?

I got an older version of this patch queued now

-Andi
