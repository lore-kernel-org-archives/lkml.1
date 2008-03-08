Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYCHQeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYCHQeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 11:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYCHQel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 11:34:41 -0500
Received: from [212.12.190.88] ([212.12.190.88]:34715 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752560AbYCHQel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 11:34:41 -0500
From: Al Boldi <a1426z@gawab.com>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Date: Sat, 8 Mar 2008 19:34:03 +0300
User-Agent: KMail/1.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200803081710.24137.a1426z@gawab.com> <alpine.DEB.1.00.0803081522240.7522@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803081522240.7522@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803081934.03331.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> On Sat, 8 Mar 2008, Al Boldi wrote:
> > Nice try, but this only works on the surface.  Try remounting root to see
> > what I mean.
>
> Are you suggesting that hpa's init= thingy doesn't support remounting
> root?

Exactly.

> If so, it'd have to be mentioned in kernel-parameters.txt as well.
>
> > Now, for a patch that actually does what we want, try this:
> > [PATCH][retry-2] init: Introduce rootdir bootparm to select which dir
> > to sys_chroot
>
> I didn't intend to introduce another bootparam, because of -ENOSKILL.
> But somewhere in this thread is a patch for the chroot= bootparam, I
> have not tested it though...

Sure,  your doc effort is much appreciated, but neither the proposed patch nor 
the init= trick works as advertised, due to some strange /dev/root 
dependencies.

Now, the rootdir= patch works around this by binding the rootdir before 
sys_chroot.


Thanks!

--
Al

