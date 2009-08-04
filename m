Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbZHDX6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbZHDX6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbZHDX6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:58:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:45922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbZHDX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:58:44 -0400
Date: Tue, 4 Aug 2009 16:52:52 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] n_tty: honor opost flag for echoes
Message-ID: <20090804235252.GB27573@suse.de>
References: <4A789AA1.5070907@skyrush.com>
 <20090804212538.GA26478@suse.de>
 <4A78A8B7.7050300@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A78A8B7.7050300@skyrush.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 03:31:35PM -0600, Joe Peterson wrote:
> Greg KH wrote:
> > On Tue, Aug 04, 2009 at 02:31:29PM -0600, Joe Peterson wrote:
> > 
> >> Fixes the following bug:
> >>
> >>       http://bugs.linuxbase.org/show_bug.cgi?id=2692
> >>
> >> Causes processing of echoed characters (output from the echo buffer) to
> >> honor the O_OPOST flag.  This re-establishes this behavior.
> >>
> >> Note that this and the next patch ("n_tty: move echoctl check and
> >> clean up logic") were verified together by the bug reporters, and
> >> all tty tests now pass.
> > 
> > What "tty tests" would that be?  Have a pointer to them?
> 
> It's the "Linux Standard Base" test suite:
> 
> 	http://www.linuxfoundation.org/collaborate/workgroups/lsb
> 
> Here's a link to the specific code - got this from one of the reporters:
> 
> http://bzr.linux-foundation.org/lsb/devel/runtime-test?cmd=content;rev=cyeoh-20020312084903-a08971416c59e5d5;pathrevid=stewb%40linux-foundation.org-20090626205411-sfb23cc0tjj7jzgm;path=modules/vsx-pcts/tset/POSIX.os/devclass/c_lflag/c_lflag.c
> 

Ah, thanks, I'll dig through it.

greg k-h
