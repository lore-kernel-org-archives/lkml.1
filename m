Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbXKSMx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbXKSMx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbXKSMxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:53:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57778 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbXKSMxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:53:45 -0500
Date: Mon, 19 Nov 2007 12:53:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFS helper functions.
Message-ID: <20071119125334.GC15942@infradead.org>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp> <20071116173524.195366292@I-love.SAKURA.ne.jp> <1195235255.7653.69.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195235255.7653.69.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 12:47:35PM -0500, Trond Myklebust wrote:
> 
> On Sat, 2007-11-17 at 02:34 +0900, penguin-kernel@I-love.SAKURA.ne.jp
> wrote:
> > plain text document attachment
> > (add-wrapper-functions-for-vfs-helper-functions.patch)
> > This patch allows LSM hooks refer previously associated "struct vfsmount" parameter
> > so that they can calculate pathname of given "struct dentry".
> 
> NACK to this. Passing function parameters through the task_struct is
> definitely not an acceptable hack

Exactly.  Having a vfsmount other than the current processes root or
current working directory in task_struct doesn't make any sense.
