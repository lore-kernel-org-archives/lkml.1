Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXLYWHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXLYWHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 17:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXLYWG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 17:06:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbXLYWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 17:06:25 -0500
Date: Tue, 25 Dec 2007 14:05:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       dhowells@redhat.com
Subject: Re: [patch, rfc] mm.h, security.h, key.h and preventing namespace
 poisoning
Message-Id: <20071225140504.f4c255d3.akpm@linux-foundation.org>
In-Reply-To: <Xine.LNX.4.64.0712201506520.6851@us.intercode.com.au>
References: <20071219093834.GW4396912@sgi.com>
	<Xine.LNX.4.64.0712201052110.1736@us.intercode.com.au>
	<20071220014413.GK4612@sgi.com>
	<Xine.LNX.4.64.0712201506520.6851@us.intercode.com.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 15:11:40 +1100 (EST) James Morris <jmorris@namei.org> wrote:

> > > +#ifdef CONFIG_SECURITY
> > > +extern unsigned long mmap_min_addr;
> > > +#endif
> > > +
> > >  #include <asm/page.h>
> > >  #include <asm/pgtable.h>
> > >  #include <asm/processor.h>
> > 
> > Fine by me.
> 
> I'll queue it for -mm & 2.6.25.

I don't think we need the ifdef.  If someone incorrectly refers to this
then they'll get a link-time error rather than a compile-time error (bad). 
But we lose an ifdef (good).

