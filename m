Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXJ3J5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXJ3J5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXJ3J5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:57:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbXJ3J47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:56:59 -0400
Date: Tue, 30 Oct 2007 09:56:53 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] VFS: swap do_ioctl and vfs_ioctl names
Message-ID: <20071030095653.GC22413@infradead.org>
References: <11936184581182-git-send-email-ezk@cs.sunysb.edu> <11936184592699-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11936184592699-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 08:40:56PM -0400, Erez Zadok wrote:
> +/**
> + * vfs_ioctl - call filesystem specific ioctl methods
> + *
> + * @filp: [in]     open file to invoke ioctl method on
> + * @cmd:  [in]     ioctl command to execute
> + * @arg:  [in/out] command-specific argument for ioctl

I've never seen these in/out annotations and doubt they're valid in
kerneldoc.  Randy?

> + * Invokes filesystem specific ->unlock_ioctl, if one exists; otherwise

unlocked_ioctl

