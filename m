Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbXLZEQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbXLZEQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 23:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXLZEQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 23:16:20 -0500
Received: from namei.org ([69.55.235.186]:51115 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbXLZEQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 23:16:19 -0500
Date: Wed, 26 Dec 2007 15:15:04 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       dhowells@redhat.com
Subject: Re: [patch, rfc] mm.h, security.h, key.h and preventing namespace
 poisoning
In-Reply-To: <20071225140504.f4c255d3.akpm@linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0712261514390.26710@us.intercode.com.au>
References: <20071219093834.GW4396912@sgi.com> <Xine.LNX.4.64.0712201052110.1736@us.intercode.com.au>
 <20071220014413.GK4612@sgi.com> <Xine.LNX.4.64.0712201506520.6851@us.intercode.com.au>
 <20071225140504.f4c255d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Dec 2007, Andrew Morton wrote:

> On Thu, 20 Dec 2007 15:11:40 +1100 (EST) James Morris <jmorris@namei.org> wrote:
> 
> > > > +#ifdef CONFIG_SECURITY
> > > > +extern unsigned long mmap_min_addr;
> > > > +#endif
> > > > +
> > > >  #include <asm/page.h>
> > > >  #include <asm/pgtable.h>
> > > >  #include <asm/processor.h>
> > > 
> > > Fine by me.
> > 
> > I'll queue it for -mm & 2.6.25.
> 
> I don't think we need the ifdef.  If someone incorrectly refers to this
> then they'll get a link-time error rather than a compile-time error (bad). 
> But we lose an ifdef (good).

Done, & rebased the git branch.


- James
-- 
James Morris
<jmorris@namei.org>
