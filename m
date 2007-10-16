Return-Path: <linux-kernel-owner+w=401wt.eu-S934028AbXJPPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbXJPPpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933178AbXJPPpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:45:24 -0400
Received: from 1wt.eu ([62.212.114.60]:3138 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987AbXJPPpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:45:23 -0400
Date: Tue, 16 Oct 2007 17:41:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: zaitcev@redhat.com, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-ID: <20071016154138.GA23326@1wt.eu>
References: <1192383445.8372.18.camel@dell1.softservecom.com> <20071014182542.GA2832@1wt.eu> <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com> <20071014223921.GA4677@1wt.eu> <1192542889.29039.66.camel@dell1.softservecom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192542889.29039.66.camel@dell1.softservecom.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 04:54:49PM +0300, Vitaliy Ivanov wrote:
> Willy,
> 
> On Mon, 2007-10-15 at 01:39, Willy Tarreau wrote:
> 
> > That's what I've seen. I can propose you something (unless someone
> > else raises his hand saying "no") : you update your patch with a
> > short description of what the hardware module is supposed to be used
> > for, and you accept to step up as the maintainer for this backport,
> > which will imply that you put your name and mail in the MAINTAINERS
> > file. That way, if you're the only user, nobody will be annoyed, and
> > if there are other users and some of them have problems, I don't waste
> > my time on something I don't know at all. If you agree with this deal
> > (which I think is fair), then I'm willing to merge your patch into
> > 2.4.36-pre.
> 
> It's completely fair. I spent some time on lkml and I liked it.
> I've a device and I can check/correct any issue we'll have with it(hope there won't be any;)).
> So it's OK for me to be a maintainer for this driver.
> 
> Here is final patch with all issues corrected.
> 
> Again, comments are welcomed.

OK, I have no objection, but please apply the fixes the le16 problem as
suggested by Pete and Greg first. Also, you will probably receive more
comments, and/or criticisms from further reviews. This is normal and
expected. You just have to fix your code so that it can be merged.

> adutux is a simple Linux device driver for ADU boards from Ontrak Control Systems. 
> The adutux driver exposes standard open/close/read/write API's to the user application.

If this is going to be the commit message, please reduce lines to less
than 70 chars, and also enumerate the supportd devices and the one you
performed the tests with. It helps a lot when users encounter problems.

Also, if you did not (I forgot to check), please ensure that the adutux
maintainer in 2.6 is CC'd.

Last but not least, please remove the "KERNELS/" path component from
your next diff.

Thanks,
Willy

