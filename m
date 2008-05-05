Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYEELAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYEELAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbYEEK7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:59:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426AbYEEK7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:59:41 -0400
Date: Mon, 5 May 2008 06:59:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [patch 01/15] ecryptfs: clean up (un)lock_parent
Message-ID: <20080505105914.GA20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095508.218321526@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095508.218321526@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:42AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> dget(dentry->d_parent) --> dget_parent(dentry)
> 
> unlock_parent() is racy and unnecessary.  Replace single caller with
> unlock_dir().
> 
> There are several other suspect uses of ->d_parent in ecryptfs...

Looks good an the first hunk is an obvious fix.  Should probably go into
.26

