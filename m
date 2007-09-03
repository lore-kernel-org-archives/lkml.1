Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbXICSql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbXICSql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXICSqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:46:33 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48730 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbXICSqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:46:32 -0400
Date: Mon, 3 Sep 2007 14:42:07 -0400
Message-Id: <200709031842.l83Ig719014512@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Boldi <a1426z@gawab.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de
Subject: Re: [GIT PULL -mm] Unionfs/fsstack/eCryptfs updates/cleanups/fixes 
In-reply-to: Your message of "Mon, 03 Sep 2007 21:26:47 +0300."
             <200709032126.47232.a1426z@gawab.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200709032126.47232.a1426z@gawab.com>, Al Boldi writes:
> Erez Zadok wrote:
> > Al, we have back-ports of the latest Unionfs to 2.6.{22,21,20,19,18,9},
> > all in http://unionfs.filesystems.org/.  Before we release any change, we
> > test it on all back-ports as well as the latest -rc/-mm code base (takes
> > over 24 hours straight to get through all of our regressions :-)
> 
> I am impressed, thanks!

You're welcome.

> It's probably a good idea to always point these backports out, whenever 
> submitting patches against -mm.  Otherwise, people might forget.

Good idea.

> > So we'd be happy to submit those patches to the latest stable kernel. 
> > But, are you talking about VFS/ecryptfs patches (which are in the stable
> > kernel), or are you talking about Unionfs (which is not)?
> 
> I'm talking about Unionfs, which seems like a rather critical feature to 
> miss-out on.

Hmmm, we'll have to discuss this among the unionfs developers first.

> BTW, did you ever get that oops-on-umount worked out?

Which bug?  Is that something anyone submitted to our
https://bugzilla.filesystems.org?  I don't recall such a bug in a while, so
if it got fixed, it must've been a while back.  If it's still there and
reproducible, please let me know asap so I can work on it.

It is possible that the bug is in the -mm code.  That's why we just posted
the long series of Unionfs patches: those patches represent more than four
months of intense hardening and testing.  Some of the bugs we've fixed had
to do with improper refcounting (esp. mnt refcounting, which, if not
perfect, either causes an EBUSY on unmount or an oops on unmount :-)

> Thanks!
> 
> --
> Al

Erez.
