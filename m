Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbXJMMkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbXJMMkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbXJMMjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:39:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57592 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbXJMMjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:39:51 -0400
Date: Sat, 13 Oct 2007 12:25:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 2/2] r/o bind mounts: Accept passing a mnt NULL pointer to mnt_drop_write()
Message-ID: <20071013112502.GA11464@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Blunck <jblunck@suse.de>, Dave Hansen <haveblue@us.ibm.com>,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
References: <20071012155019.747515889@hasse.suse.de> <20071012155020.197228145@hasse.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012155020.197228145@hasse.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 05:50:21PM +0200, Jan Blunck wrote:
> In case of somebody opens a file with dentry_open(dentry, NULL, ...) we don't
> want to stumble on the NULL pointer mnt in struct file.

We should just not allow a NULL vfsmount in dentry_open.  Dave and I have
fixes for reiserfs, and I'll look at the uml use.

