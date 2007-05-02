Return-Path: <linux-kernel-owner+w=401wt.eu-S2992764AbXEBGJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992764AbXEBGJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992788AbXEBGJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:09:08 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992764AbXEBGJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:09:06 -0400
Date: Tue, 1 May 2007 23:08:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-Id: <20070501230858.b29564ef.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705012252020.21669@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
	<20070502051723.GB5843@martell.zuzino.mipt.ru>
	<Pine.LNX.4.64.0705012252020.21669@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 22:53:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Wed, 2 May 2007, Alexey Dobriyan wrote:
> 
> > On Tue, May 01, 2007 at 09:28:18PM -0700, David Rientjes wrote:
> > > +#define __attribute_unused__		__attribute__((unused))
> > 
> > Suggest __unused which is shorter and looks compiler-neutral.
> > 
> 
> So you would also suggest renaming __attribute_used__ and all 48 of its 
> uses to __used?

Or __needed or __unneeded.  None of them mean much to me and I'd be forever
going back to the definition to work out what was intended.

We're still in search of a name, IMO.  But once we have it, yeah, we should
update all present users.  We can do that over time: retain the old and new
definitions for a while.

