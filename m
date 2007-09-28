Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXI1JUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXI1JUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXI1JUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:20:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:46207 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbXI1JU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q/htWy3kxUhCsE+/cfkc/NjePy6HfiW7CieDul0iLnwdP8rcOzNicJp8Dtkjg+I0rS+K7ByWm53xrtEEBgsa5Lb4sUX3tD/c0h5KtUCjvpDZmuDEHmHJkMcv/MT623KLW1sC9to+SkGsqBVvtRw3j1Ef3v4U6nJO+QwTMS5sdW8=
Message-ID: <92cbf19b0709280220o7cdd4b1cua37a8776af68ac25@mail.gmail.com>
Date: Fri, 28 Sep 2007 02:20:28 -0700
From: "Chakri n" <chakriin5@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
In-Reply-To: <1190970729.31636.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190962752.31636.15.camel@twins>
	 <92cbf19b0709280127yba48b60wfe58e532944894ca@mail.gmail.com>
	 <1190968800.31636.26.camel@twins>
	 <92cbf19b0709280201o3778f945mf1d8d61cbb3d0558@mail.gmail.com>
	 <1190970729.31636.29.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's 2.6.23-rc6.

Thanks
--Chakri

On 9/28/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2007-09-28 at 02:01 -0700, Chakri n wrote:
> > Thanks for explaining the adaptive logic.
> >
> > > However other devices will at that moment try to maintain a limit of 0,
> > > which ends up being similar to a sync mount.
> > >
> > > So they'll not get stuck, but they will be slow.
> > >
> > >
> >
> > Sync should be ok, when the situation is bad like this and some one
> > hijacked all the buffers.
> >
> > But, I see my simple dd to write 10blocks on local disk never
> > completes even after 10 minutes.
> >
> > [root@h46 ~]# dd if=/dev/zero of=/tmp/x count=10
> >
> > I think the process is completely stuck and is not progressing at all.
> >
> > Is something going wrong in the calculations where it does not fall
> > back to sync mode.
>
> What kernel is that?
>
>
>
