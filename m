Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYCVHOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYCVHOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 03:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYCVHOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 03:14:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52542 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYCVHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 03:14:33 -0400
Date: Sat, 22 Mar 2008 00:19:26 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
Message-ID: <20080322071926.GA1743@kroah.com>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de> <200803220226.35552.rjw@sisk.pl> <20080321222606.16407d74.akpm@linux-foundation.org> <20080322062025.GA28146@kroah.com> <20080321232632.84a2af8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321232632.84a2af8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 11:26:32PM -0700, Andrew Morton wrote:
> On Fri, 21 Mar 2008 23:20:25 -0700 Greg KH <greg@kroah.com> wrote:
> 
> > > - we're killing people's machines.  Can we switch it to a
> > >   WARN_ON()+fix-up-the-mess?
> > 
> > The patch above does just that, it's queued up for .26, but I have no
> > objection to add it now if you want.
> 
> It'd be best to do so, I think.
> 
> Upsides: we get more debug info and we might save people's machines
> 
> Downsides: ???

Ok, I'll move it up the stack to send to Linus on Monday.

thanks,

greg k-h
