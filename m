Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbXA3Xmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbXA3Xmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXA3Xmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:42:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:28736 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXA3Xmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:42:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o1fIhCmEOouRq0NCad7VgNnlYrjZQ6lBcBsN/1nfLu/sThfUxHYdq624p6C2qNBa1lWbFAhk0SVG+lL8PAMd1wT6mv2abDRjJzqF9OfsK5XjMkJLwXWuiISCuD/Rbr7P8seBtABMdMvv94wHkPTYmwXMUwFNSazPe+8yZIEjHkw=
Message-ID: <9a8748490701301542r33317ca7id9deb63fca2fb2dc@mail.gmail.com>
Date: Wed, 31 Jan 2007 00:42:43 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: [NFS] 2.6.17.8 - do_vfs_lock: VFS is out of sync with lock manager!
Cc: "Neil Brown" <neilb@suse.de>, nfs@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1170080210.5757.6.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490608080739w2e14e5ceg44a7bf0a3b475704@mail.gmail.com>
	 <17636.4462.975774.528003@cse.unsw.edu.au>
	 <9a8748490608170258s32df0272r60c8c540e5871485@mail.gmail.com>
	 <17641.10665.116168.867041@cse.unsw.edu.au>
	 <1156190098.6158.109.camel@localhost>
	 <17853.33116.113629.65031@notabene.brown>
	 <1170080210.5757.6.camel@lade.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> On Mon, 2007-01-29 at 16:08 +1100, Neil Brown wrote:
> > On Monday August 21, trond.myklebust@fys.uio.no wrote:
> > >
> > > Could we instead replace it with a dprintk() that returns the value of
> > > "res"? That will keep it useful for debugging purposes.
> >
> > (only 5 months later...)
> >
> > Sure, how about this?
> >
> > Thanks,
> > NeilBrown
>
> ACKed.
>
> Thanks Neil!
>

Finally getting that in will be sooooo nice :-)  Thank you.

Btw: any reason why not to include the
  fl->fl_flags &= ~FL_SLEEP;
bit as well?  As in http://lkml.org/lkml/2006/11/27/41  ??


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
