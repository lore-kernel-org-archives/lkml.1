Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbZL3BDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbZL3BDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZL3BDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:03:35 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:40908 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZL3BDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:03:35 -0500
Date: Tue, 29 Dec 2009 20:03:01 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove macro MAXHOSTNAMELEN from
 <asm-generic/param.h>.
In-Reply-To: <20091230115610.c10599b8.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.0912292002370.6803@localhost>
References: <alpine.LFD.2.00.0912291929010.6325@localhost> <20091230115610.c10599b8.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009, Stephen Rothwell wrote:

> Hi Robert,
>
> On Tue, 29 Dec 2009 19:32:15 -0500 (EST) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> >
> > Since nothing in the entire tree makes use of this macro, remove
> > it. This removal should eventually propagate to all of the
> > arch-specific param.h files.
>
> Except if the only place this is picked up by glibc is the kernel
> header files, then it will disappear from user mode and some
> packages may break.

  true, but this still takes me back to my original observation -- why
is this macro being defined in a kernel header file if the kernel
itself has absolutely no interest in it and doesn't use it in any way?

  if glibc wants it, it might as well define it.

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
