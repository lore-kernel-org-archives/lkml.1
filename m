Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0CGQBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 11:01:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:49657 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab0CGQBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 11:01:23 -0500
Date: Sun, 7 Mar 2010 07:50:03 -0800
From: Greg KH <gregkh@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH -next] staging/pohmelfs: fix write_inode parameter
	warning
Message-ID: <20100307155003.GA1615@suse.de>
References: <20100225183523.80361261.sfr@canb.auug.org.au> <20100225144122.d9ba8810.randy.dunlap@oracle.com> <10f740e81003070122y32765942y33c167b5ba4ca8ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f740e81003070122y32765942y33c167b5ba4ca8ac@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 10:22:27AM +0100, Geert Uytterhoeven wrote:
> On Thu, Feb 25, 2010 at 23:41, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > sparse warns that:
> 
> Not just sparse, plain gcc as well...
> 
> > drivers/staging/pohmelfs/inode.c:1797: warning: initialization from incompatible pointer type
> >
> > so fix pohmelfs_write_inode() to have the expected parameters.
> 
> And now it's in mainline, too...

This fix is queued up in the tree already sent to Linus so it should all
be resolved soon.

thanks,

greg k-h
