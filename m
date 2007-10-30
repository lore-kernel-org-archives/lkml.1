Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbXJ3P0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbXJ3P0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXJ3P0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:26:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34063 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbXJ3P0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:26:05 -0400
Date: Tue, 30 Oct 2007 16:26:04 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Blunck <jblunck@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 0/2] readdir() as an inode operation
Message-ID: <20071030152604.GC27039@atrey.karlin.mff.cuni.cz>
References: <20071020100903.717837398@X40.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020100903.717837398@X40.localnet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a first try to move readdir() to become an inode operation. This is
> necessary for a VFS implementation of "something like union-mounts" where a
> readdir() needs to read the directory contents of multiple directories.
> Besides that the new interface is no longer giving the struct file to the
> filesystem implementations anymore.
> 
> Comments, please?
  Hmm, are you sure there are no users which keep some per-struct-file
information for directories? File offset is one such obvious thing which
you've handled but actually filesystem with more complicated structure
of directory may remember some hints about where we really are, keep
some readahead information or so...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
