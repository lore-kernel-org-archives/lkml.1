Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXENBax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXENBax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 21:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbXENBaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 21:30:46 -0400
Received: from ozlabs.org ([203.10.76.45]:53074 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbXENBap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 21:30:45 -0400
Subject: Re: [PATCH 1/5] lguest host feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       hch <hch@infradead.org>
In-Reply-To: <20070513184750.GA4095@ftp.linux.org.uk>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
	 <1179029245.23513.121.camel@localhost.localdomain>
	 <20070513184750.GA4095@ftp.linux.org.uk>
Content-Type: text/plain
Date: Mon, 14 May 2007 11:30:30 +1000
Message-Id: <1179106230.23513.136.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 19:47 +0100, Al Viro wrote:
> On Sun, May 13, 2007 at 02:07:25PM +1000, Rusty Russell wrote:
> > Most importantly, I now realize that Christoph's incorrect ranting
> > about lgread_u32 et al was in fact a subtle ploy to make me diagnose
> > the real issue: sparse 0.3 complains about casting a __user pointer
> > to/from u32, but not an "unsigned long".  They are (currently)
> > equivalent for lguest, but this is a much better solution than __force.
> 
> The real fix would be to declare it with u32 __user * as argument and deal
> with callers.

Hi Al.

	Arguments come in from the guest in registers.  I could use a funky
union in the structure definition, but I don't think we're winning
anything at that point.

Hope that clarifies,
Rusty.

