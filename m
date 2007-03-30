Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbXC3UAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbXC3UAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXC3UAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:00:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbXC3UAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:00:31 -0400
Date: Fri, 30 Mar 2007 13:00:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Mitch Williams <mitch.a.williams@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
Message-Id: <20070330130022.862f6849.akpm@linux-foundation.org>
In-Reply-To: <20070330194956.GA8028@suse.de>
References: <1175280848.17652.5.camel@strongmad>
	<m1irciime5.fsf@ebiederm.dsl.xmission.com>
	<20070330124747.f20c9eb0.akpm@linux-foundation.org>
	<20070330194956.GA8028@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 12:49:56 -0700
Greg KH <gregkh@suse.de> wrote:

> > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > Did we end up deciding whether this is (needed*safe) enough for 2.6.21?
> 
> I say no for now, I have seen no bug reports for any hardware that is
> not in a lab for this.

Well.  Presumably that hardware will be in the field during the lifetime of
2.6.21-based kernels.

Perhaps we should put this into 2.6.22 then backport it to 2.6.21.x once it
seems safe to do so.  If we decide to go this way, we'll need to ask Mitch
to remind us to do the backport at the appropriate time, else we'll surely
forget.

