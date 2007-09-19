Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbXISR27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbXISR27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbXISR2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:28:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53870 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbXISR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:28:44 -0400
Date: Wed, 19 Sep 2007 18:28:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 04/24] r/o bind mounts: stub functions
Message-ID: <20070919172843.GD20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182723.3DC633F9@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182723.3DC633F9@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:23AM -0700, Dave Hansen wrote:
> 
> This patch adds two function mnt_want_write() and
> mnt_drop_write().  These are used like a lock pair around
> and fs operations that might cause a write to the filesystem.
> 
> Before these can become useful, we must first cover each
> place in the VFS where writes are performed with a
> want/drop pair.  When that is complete, we can actually
> introduce code that will safely check the counts before
> allowing r/w<->r/o transitions to occur.

kerneldoc comments, please!

Otherwise looks fine.

