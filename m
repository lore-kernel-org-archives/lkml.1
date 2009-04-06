Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZDFBNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZDFBNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 21:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZDFBM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 21:12:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZDFBM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 21:12:58 -0400
Date: Sun, 5 Apr 2009 18:07:54 -0700
From: Greg KH <gregkh@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Christopher Harrer <charrer@alacritech.com>
Subject: Re: Staging: sxg: Add support to download the firmware using
	request_firmware()
Message-ID: <20090406010754.GA32630@suse.de>
References: <200904051919.n35JJUUq031448@hera.kernel.org> <1238978493.11870.2.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238978493.11870.2.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 05:41:33PM -0700, David Woodhouse wrote:
> On Sun, 2009-04-05 at 19:19 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/linus/cda3b517a478324233d9be71232b60e2e2efe848
> > Commit:     cda3b517a478324233d9be71232b60e2e2efe848
> > Parent:     e5ea8da06ba610551a75c79c1467aae379e953ce
> > Author:     Mithlesh Thukral <mithlesh@linsyssoft.com>
> > AuthorDate: Fri Mar 20 17:39:04 2009 +0530
> > Committer:  Greg Kroah-Hartman <gregkh@suse.de>
> > CommitDate: Fri Apr 3 14:53:14 2009 -0700
> > 
> >     Staging: sxg: Add support to download the firmware using request_firmware()
> >     
> >     Add support for downloading the firmware using kernel-builtin mechanism.
> >     This will remove the need for the firmware files in the driver source code.
> >     
> >     Signed-off-by: Christopher Harrer <charrer@alacritech.com>
> >     Signed-off-by: Mithlesh Thukral <mithlesh@linsyssoft.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  drivers/staging/sxg/saharadbgdownload-1.71.c  | 5233 ------------------------
> >  drivers/staging/sxg/saharadbgdownloadB-1.10.c | 5251 -------------------------
> >  drivers/staging/sxg/saharadownload-1.55.c     | 4531 ---------------------
> >  drivers/staging/sxg/saharadownloadB-1.8.c     | 4532 ---------------------
> >  drivers/staging/sxg/sxg.c                     |  206 +-
> >  firmware/Makefile                             |    2 +
> >  firmware/WHENCE                               |   12 +
> >  firmware/sxg/saharadbgdownloadB.sys.ihex      | 3937 ++++++++++++++++++
> >  firmware/sxg/saharadownloadB.sys.ihex         | 3385 ++++++++++++++++
> >  9 files changed, 7437 insertions(+), 19652 deletions(-)
> 
> NO!
> 
> What the hell are you playing at, Greg?
> 
> We don't want to be adding _new_ binary firmware into the firmware/
> directory -- that was only the temporary location for removing the
> _existing_ crap.

Is that written anywhere that I missed?  If so, sorry, I didn't realize
that.

> We have the linux-firmware.git repository, into which we are collecting
> new firmware blobs. Don't add them to the kernel sources.

Who do we email to add this to?

And finally, what's wrong with adding new firmware images into the
firmware/ directory?  What is the issue here?

thanks,

greg k-h
