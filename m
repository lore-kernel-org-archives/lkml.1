Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbXCYHeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbXCYHeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 03:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXCYHeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 03:34:07 -0400
Received: from ozlabs.org ([203.10.76.45]:59210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbXCYHeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 03:34:05 -0400
Subject: Re: [-mm patch] lguest: #if 0 check_bug_kill()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070324130639.GG752@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <20070324130639.GG752@stusta.de>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 17:33:45 +1000
Message-Id: <1174808025.6281.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-24 at 14:06 +0100, Adrian Bunk wrote:
> On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.21-rc3-mm1:
> >...
> > +lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
> >...
> >  x86/x86_64 updates
> >...
> 
> 
> check_bug_kill() is no longer used.

Thanks Adrian, that was actually an oversight.  However, this function
is most useful in early bringup, so I didn't notice it was gone.

I'd prefer a patch which eliminates it altogether, rather than #if 0 it
out.

Thanks!
Rusty.


