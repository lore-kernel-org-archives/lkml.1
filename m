Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXA2Ukm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXA2Ukm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXA2Ukm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:40:42 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50491 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbXA2Ukl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:40:41 -0500
Date: Mon, 29 Jan 2007 15:40:01 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 4/4] fs/unionfs/: Don't duplicate the struct nameidata
Message-ID: <20070129204000.GC1715@filer.fsl.cs.sunysb.edu>
References: <11701030631109-git-send-email-jsipek@cs.sunysb.edu> <11701030642806-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11701030642806-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 03:37:43PM -0500, Josef 'Jeff' Sipek wrote:
> Josef 'Jeff' Sipek (3):
>       fs/unionfs/: Remove stale_inode.c
>       fs/unionfs/: Andrew Morton's comments
>       fs/unionfs/: Don't duplicate the struct nameidata
> 
>  fs/unionfs/branchman.c   |    4 +-
>  fs/unionfs/commonfops.c  |   54 +++++++++++-----------
>  fs/unionfs/copyup.c      |   67 +++++++++++++++------------
>  fs/unionfs/dentry.c      |   19 +++-----
>  fs/unionfs/fanout.h      |   51 +++++++++++++++++----
>  fs/unionfs/file.c        |   17 +++-----
>  fs/unionfs/inode.c       |   69 +++++++++++++++-------------
>  fs/unionfs/lookup.c      |  113 +++++++++++++++++++++++-----------------------
>  fs/unionfs/main.c        |   32 +++++++-------
>  fs/unionfs/rdstate.c     |    2 +-
>  fs/unionfs/rename.c      |    8 ++--
>  fs/unionfs/sioq.c        |   19 ++++----
>  fs/unionfs/sioq.h        |    1 -
>  fs/unionfs/stale_inode.c |  112 ---------------------------------------------
>  fs/unionfs/subr.c        |   65 +++++++++++++++++++++++++-
>  fs/unionfs/super.c       |    7 +--
>  fs/unionfs/union.h       |   84 +++-------------------------------
>  fs/unionfs/unlink.c      |    8 ++--
>  fs/unionfs/xattr.c       |   16 +++---
>  19 files changed, 330 insertions(+), 418 deletions(-)

Not sure why this was sent. The other 4/4 email is the correct one.

Josef "Jeff" Sipek.

-- 
Bad pun of the week: The formula 1 control computer suffered from a race
condition
