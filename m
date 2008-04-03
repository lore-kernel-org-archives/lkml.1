Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbYDCBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbYDCBBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYDCBAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:00:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49474 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYDCBAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:00:49 -0400
Date: Thu, 3 Apr 2008 02:00:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080403010016.GU9785@ZenIV.linux.org.uk>
References: <1207183329.20254.49.camel@heimdal.trondhjem.org> <200804030047.m330l6Pf032755@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804030047.m330l6Pf032755@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 08:47:06PM -0400, Erez Zadok wrote:
> In message <1207183329.20254.49.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> > 
> > On Thu, 2008-04-03 at 00:47 +0100, Al Viro wrote:
> [...]
> > >  Again, what for?
> > 
> > It allows you to get rid of the vfsmount 'argument' when opening a file,
> > which again lowers the barrier for stacking filesystems.
> > 
> > As far as the filesystems themselves are concerned, the effect is to
> > enforce your assertion that file operations should not depend on the
> > namespace.
> 
> I'd be delighted the day I won't have to deal with vfsmounts AT ALL in
> any stacked f/s.

vfsmounts or the fact that any fs may be mounted in many places?
