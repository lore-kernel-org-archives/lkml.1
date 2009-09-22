Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZIVN4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZIVN4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZIVN4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:56:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbZIVN4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:56:09 -0400
Date: Tue, 22 Sep 2009 09:56:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH] vfs: new FROM_ACCESS flag
Message-ID: <20090922135612.GA17769@infradead.org>
References: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 09:30:48PM -0400, Eric Paris wrote:
> This new acc_mode flag is just to tell the security system this inode
> permission check is from the access system call.  The security system can
> use this information as it finds appropriete.  In particular SELinux plans to
> use this flag to alter what we choose to audit and what we do not choose to
> audit.

I think you're better off splitting the existing MAY_ACCESS flag and
only using MAY_ACCESS for calles from access() insteaf of introducing
a FROM_ACCESS flag and causing lots of naming confusion.

