Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYKXLW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYKXLW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKXLWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:22:47 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:35992 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYKXLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:22:47 -0500
Date: Mon, 24 Nov 2008 12:24:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jim Radford <radford@galvanix.net>
Subject: Re: [RFC PATCH] kbuild: move tags support to a shell script
Message-ID: <20081124112410.GA13820@uranus.ravnborg.org>
References: <20081122231631.GA6456@uranus.ravnborg.org> <1227522668.9425.21.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227522668.9425.21.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 10:31:08AM +0000, Ian Campbell wrote:
> On Sun, 2008-11-23 at 00:16 +0100, Sam Ravnborg wrote:
> > As no-one else wanted to do so - I now moved the tags support
> > to a shell script of its own.
> > The usage is the same: make {tags,TAGS,cscope}
> > 
> > The ALLSOURCE_ARCHS suppport was lost in the transition - is it actually used by anyone?
> 
> I'm the one who actually added it way back in
> a0674e88d9c150e016a69e78e735f48772314c53 and to be honest I don't use it
> anymore since I've changed jobs and only really do x86 now...
> 
> I can't say if anyone else is using it though.
> 
> > I have given the patch only some light testing.
> > 
> > Could those of you that actually sues tags/cscope plese give it a try.
> 
> I tested your second patch from the subsequent email and functionally it
> seems fine, it currently includes include/asm-* for all architectures
> but I suppose they will all go away shortly.
> 
> The output was a bit odd though:
>         $ make cscope
>         /bin/sh /local/scratch/ianc/devel/linux-2.6.git/scripts/tags.sh cscope
>           GEN     cscope.out (from 13251 files)
> I guess I would have expected "  GEN     cscope.files" instead of the
> first line or just "  TAGS"?

Thanks for testing Ian.

I will fix up the invocation line to something like
  GEN    {tags,TAGS,cscope}

And then I will drop the extra output from the shell script
in the cscope case.

Is it OK that I add a:

Tested-by: Ian Campbell <ijc@hellion.org.uk>

to the patch?

	Sam
