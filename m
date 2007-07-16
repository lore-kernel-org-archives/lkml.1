Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbXGPXEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbXGPXEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXGPXEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:04:24 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:42257 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbXGPXEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:04:24 -0400
Date: Mon, 16 Jul 2007 19:04:20 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: wrong order of arguments of ->readdir()
Message-ID: <20070716230420.GB22534@delft.aura.cs.cmu.edu>
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200707152359.l6FNx3oN023117@hera.kernel.org> <20070716134424.0cd870b4.akpm@linux-foundation.org> <20070716204930.GK21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716204930.GK21668@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 09:49:30PM +0100, Al Viro wrote:
> > c) Jan's patch was not cc'ed to any mailing list
>  
> ... said patch (presumably being an obvious fix of obvious roothole)
> had not been sent to mainline immediately.

The exploiting application would have to run in the role of the
userspace cache manager. In other words, you need to,

  - open /dev/cfs0
  - mount the Coda filesystem and pass the file handle of the opened
    cfs0 device as one of the mount options

Both of these actions already require root, and if you can get this far
without root priviledges it would be considerably easier to just hand a
setuid root shell through the mounted Coda file system.

So I didn't consider this a critical root hole.

> > d) Al's patch was not sent to the maintainer.  Nor to me.  Nor was it
> >    staged in any tree which I can get at so that I could inform people of
> >    the upcoming conflict/duplication/etc.
>  
> Coda is still maintained?  That's certainly news to me - I'm not being
> sarcastic, but my impression had been that coda got abandoned several
> years ago.

Well, in that case someone forgot to update the MAINTAINERS file.

Jan
