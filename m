Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbXHQGzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbXHQGzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXHQGyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:54:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbXHQGyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:54:51 -0400
Date: Thu, 16 Aug 2007 23:54:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] autofs4: deadlock during create
Message-Id: <20070816235427.7563103e.akpm@linux-foundation.org>
In-Reply-To: <1187322972.3560.12.camel@raven.themaw.net>
References: <1187087280.4963.18.camel@raven.themaw.net>
	<x49mywuci9i.fsf@segfault.boston.devel.redhat.com>
	<1187159503.3249.36.camel@raven.themaw.net>
	<1187322972.3560.12.camel@raven.themaw.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 11:56:11 +0800 Ian Kent <raven@themaw.net> wrote:

> On Wed, 2007-08-15 at 14:31 +0800, Ian Kent wrote:
> > On Tue, 2007-08-14 at 10:17 -0400, Jeff Moyer wrote:
> > > Ian Kent <raven@themaw.net> writes:
> > > >
> > > > After spending quite a bit of time trying to resolve this on more than
> > > > one occassion, using rather complex and ulgy approaches, it turns out
> > > > that just delaying the hashing of the dentry until the create operation
> > > > work fine.
> > 
> > There seems to be an unexpected problem with the patch after removal of
> > the d_rehash line left in the original by mistake.
> > 
> 
> I see you haven't got to this yet, probably because I used your old
> email address, 

Actually my cursor has advanced that far, but you said it didn't work right
yet.

> so to save hassle, here is the final patch and the
> description.

OK, thanks.

