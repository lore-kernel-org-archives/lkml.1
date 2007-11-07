Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbXKGSak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbXKGSak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbXKGSa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:30:27 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39223 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341AbXKGSa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:30:26 -0500
Date: Wed, 7 Nov 2007 13:30:01 -0500
Message-Id: <200711071830.lA7IU1Di023742@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: David Howells <dhowells@redhat.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       akpm@linux-foundation.org, unionfs@filesystems.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Unionfs] Re: [PATCH] IGET: Stop UnionFS from using iget() and read_inode() 
In-reply-to: Your message of "Wed, 07 Nov 2007 09:14:27 CST."
             <1194448467.3140.6.camel@albrecht.rdi1.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1194448467.3140.6.camel@albrecht.rdi1.com>, Paul Albrecht writes:
> On Wed, 2007-11-07 at 15:04 +0000, David Howells wrote:
> > Paul Albrecht <albrecht@rdi1.com> wrote:
> > 
> > > Does your test set include readahead-list? I can't get it to work with a
> > > union mounted filesystem without segfault'ing and kernel oops'ing.
> > 
> > Is that with or without this patch?
> 
> Without ... what's the difference? I asked a specific question about the
> test set that was used to validate unionfs and your fix.  
> 
> Paul Albrecht

Paul,

I'll check out the readahead stuff shortly.  I doubt the iget patch has
anything to do with it.

Cheers,
Erez.
