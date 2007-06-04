Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXFDLZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXFDLZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXFDLZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:25:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:33707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbXFDLZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:25:48 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Date: Mon, 4 Jun 2007 13:25:30 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200705231816.46197.agruen@suse.de> <20070604105526.GE4363@elf.ucw.cz>
In-Reply-To: <20070604105526.GE4363@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041325.30817.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 12:55, Pavel Machek wrote:
> On Wed 2007-05-23 18:16:45, Andreas Gruenbacher wrote:
> > On Tuesday 15 May 2007 11:14, Pavel Machek wrote:
> > > Why is this configurable?
> >
> > The maximum length of a pathname is an arbitrary limit: we don't want to
> > allocate arbitrary amounts of of kernel memory for pathnames so we
> > introduce this limit and set it to a reasonable value. In the unlikely
> > case that someone uses insanely long pathnames, this limit can be
> > increased.
>
> vfs does not have configurable pathname limit, and I do not see what
> is so special about AA to require this kind of uglyness.

You very well know that the vfs has a limit of PATH_MAX characters (4096) for 
pathnames. This means that at most that many characters can be passed at 
once. 

I've really got enough of your perpetual unfounded rants.
