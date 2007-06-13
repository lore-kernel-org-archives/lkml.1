Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbXFMRK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbXFMRK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbXFMRKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:10:49 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48770 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967AbXFMRKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:10:48 -0400
Date: Wed, 13 Jun 2007 19:11:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: holzheu@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070613171148.GA24610@uranus.ravnborg.org>
References: <1181747217.29512.9.camel@localhost.localdomain> <1181752649.15815.68.camel@spirit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181752649.15815.68.camel@spirit>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 09:37:29AM -0700, Dave Hansen wrote:
> On Wed, 2007-06-13 at 17:06 +0200, holzheu wrote:
> > The operation of a Linux system sometimes requires to decode the
> > meaning of a specific kernel message, e.g. an error message of a
> > driver. Especially on our mainframe zSeries platform system
> > administrators want to have descriptions for Linux kernel messages.
> > They are used to that, because all other operating systems on that
> > platform like z/OS, z/VM or z/VSE have message catalogs with detailed
> > descriptions about the semantics of the messages.
> 
> I'm not sure we want to make Linux more like z/* in this regard. :)
> 
> The problem with your proposal is that every time a new message in the
> kernel is created or modified, you need somebody to go update that
> documentation.  It's going to get out-of-sync very fast if this isn't
> done, and you either need to convince and teach each and every kernel
> contributor to follow your lead, or have a team of highly trained code
> monkeys to watch git-commits and resubmit documentation for every diff
> that touches a printk. 

This is no more and no less the same situation that we have with
the kernel-doc documented functions/data in the kernel.

I like the concept that the description is kept close to the actual
usage, the tool support and that in general looks like ordinary
kernel-doc documentation.

And if people do not dare to update the kernel-doc documentation of
a function then maybe they should not send patches in first place..

If we then really want to have the important printk's documented
is another story.

	Sam
