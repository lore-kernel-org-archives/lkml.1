Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbXE3LeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbXE3LeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXE3LeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:34:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45708 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751477AbXE3LeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:34:08 -0400
Date: Wed, 30 May 2007 06:34:03 -0500
From: Robin Holt <holt@sgi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephane Eranian <eranian@frankl.hpl.hp.com>, linux-kernel@vger.kernel.org,
       eranian@hpl.hp.com
Subject: Re: [PATCH 02/22] 2.6.22-rc3 perfmon2 : generic kernel modifications
Message-ID: <20070530113403.GA14480@lnx-holt.americas.sgi.com>
References: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com> <20070530004658.732451ad.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530004658.732451ad.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 12:46:58AM +1000, Stephen Rothwell wrote:
> On Tue, 29 May 2007 06:48:16 -0700 Stephane Eranian <eranian@frankl.hpl.hp.com> wrote:
> >
> > Only in linux-2.6.22/Documentation: perfmon2.txt
> 
> Did part of the patch go missing?
> 
> > diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/Makefile linux-2.6.22/Makefile
> > --- linux-2.6.22.base/Makefile	2007-05-29 03:17:15.000000000 -0700
> > +++ linux-2.6.22/Makefile	2007-05-29 03:24:14.000000000 -0700
> > @@ -553,7 +553,7 @@ export mod_strip_cmd
> >
> >
> >  ifeq ($(KBUILD_EXTMOD),)
> > -core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> > +core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/
> 
> This should go near the end of the patch set so that the kernel will
> build at each step (if at all possible).
> 
> Seeing as what is missing below, naybe you should reorder the patch set
> so that the generic changes are at the end i.e. introduce all the new
> files and then wire them into the current ifrastructure.

That breaks git-bisect.  Just introducing new text, but not actually using
it makes it appear to somebody using git-bisect to identify the source of
a problem as though all the changes came in at the same time.  Bad idea.

Thanks,
Robin
