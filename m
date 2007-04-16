Return-Path: <linux-kernel-owner+w=401wt.eu-S1030751AbXDPPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030751AbXDPPXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030755AbXDPPXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:23:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33358 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030751AbXDPPXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:23:19 -0400
Date: Mon, 16 Apr 2007 17:23:18 +0200
From: Jan Kara <jack@suse.cz>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070416152318.GG25785@atrey.karlin.mff.cuni.cz>
References: <20070306164447.GC3661@duck.suse.cz> <20070330045923.GA5528@dose.home.local> <460D51AA.2080307@redhat.com> <20070331094631.GA24220@thinkpad.home.local> <461117BB.5040705@redhat.com> <20070404063620.GA5465@dose.home.local> <20070412160112.GD23348@duck.suse.cz> <20070412155946.GA7613@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412155946.GA7613@dose.home.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 12, 2007 at 18:01:12 +0200, Jan Kara wrote:
> > On Wed 04-04-07 08:36:20, Tino Keitel wrote:
> > > On Mon, Apr 02, 2007 at 10:48:27 -0400, Chuck Ebbert wrote:
> > > 
> > > [...]
> > > 
> > > > Well, it works for me on 32-bit as well, right up to 100% full.
> > > > No problems at all...
> > > 
> > > Maybe it depends on the kernel. I patched 2.6.20 with the patches
> > > above and got the described behaviour.
> >   I've sent you an email with a few questions but probably it got lost in
> > the noise... Are you able to reproduce the problem? Have you reproduced the
> > problem on a freshly created UDF image or was it some older image?
> 
> Hi,
> 
> I can't remember of any errors in the kernel or about not available
> space. It was an image file that I expermimented with, and I did
> multiple mkudffs runs on the file. Could it be that the behaviour was
> caused by stale data inside the image?
  OK, thanks for info. Umm, I don't find it likely that some stale data
in the image would cause this but maybe something could confuse mkudffs
(like it was expecting zeros somewhere where they were not). If you had
some recipe how to reproduce the problem (it would be enough if you had
something like: I have this file, I run mkudffs, mount it, see wrong
free blocks count), I can have a look at it. Otherwise, it's hard to
track it down...

								Honza
