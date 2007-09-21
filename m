Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbXIUMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbXIUMp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXIUMpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:45:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49411 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbXIUMpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:45:06 -0400
Date: Fri, 21 Sep 2007 13:45:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
Message-ID: <20070921124504.GC8088@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921123336.095183254@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 02:23:48PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new filesystem flag, that results in the VFS not checking if the
> current process has enough privileges to do an mknod().
> 
> This is needed on filesystems, where an unprivileged user may be able
> to create a device node, without causing security problems.

A user should never be able to create devices.  And no, I don't want to
see a filesystem that implements it's own file operations for device nodes.

