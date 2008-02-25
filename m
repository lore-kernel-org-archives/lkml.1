Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYBYXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYBYXVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYBYXVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:21:39 -0500
Received: from 1wt.eu ([62.212.114.60]:2130 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbYBYXVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:21:38 -0500
Date: Tue, 26 Feb 2008 00:21:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: Oleg Verych <olecom@gmail.com>
Cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20080225232133.GZ8953@1wt.eu>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <8499950a0802251417l7a2fff25q7fa57fce57369b1b@mail.gmail.com> <20080225221953.GX8953@1wt.eu> <8499950a0802251432q1e59e542nfa06f66becef63aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8499950a0802251432q1e59e542nfa06f66becef63aa@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:32:44PM +0100, Oleg Verych wrote:
> On Mon, Feb 25, 2008 at 11:19 PM, Willy Tarreau:
> >
> > On Mon, Feb 25, 2008 at 11:17:23PM +0100, Oleg Verych wrote:
> >  > On Mon, Feb 25, 2008 at 10:42 PM, Steve Brokenshire:
> >  > > Hi,
> >  > >
> >  > >  (I've sent this to the linux-kbuild and linux-kernel lists as this
> >  > >  patch modifies the Makefile.modinst file. I also don't subscribe to the
> >  > >  linux-kbuild and linux-kernel mailing lists so can I have any replies
> >  > >  CC'ed to me please)
> >  >
> >  > And what if i like bzip2 (yea sometimes better) or 7zip (better if !EMBEDDED)
> >  > or whatever?
> >  >
> >  > It's pure user/distro question.
> >
> >  not exactly, as only gzip is supported by module-init-tools. However,
> >  if you come up with a patch to implement lzma or equivalent for
> >  module-init-tools, it may be useful.
> 
> Oh, come on! It's userspace,

and your point is ... ?

> i have scripts managing existence/compression
> on per-file basis on my comp.

I'm definitely happy for you.

> If most distros just drop thousands of useless
> (sometimes compressed) stuff to your harddisk, it's not kernel's or
> modules-init-tools' problem.

who said there was a problem ?

> Also having compressed over compressed stuff, like on initramfs booting image
> with such modules (if by defaults) may cause bigger file, more CPU overhead.

Already known and obvious, thanks. But that's unrelated to the initial post.

> It is userspace and all that policy stuff, etc., etc.

A makefile is userspace too. I still fail to see your point.
 
> Want to make a minidistro on lkml? Well, i see klibc working fine already.

Huh? drinking before posting does no good it seems... :-)

Steve proposed a simple patch to ease modules compression during the
build process. Obviously it's userspace (as all the build process,
mind you). And there's nothing dirty nor funny there. Maybe you just
don't understand what it's useful for, but in this case it simply means
you don't need this feature :-)

Willy

