Return-Path: <linux-kernel-owner+w=401wt.eu-S1763164AbXJTKLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763164AbXJTKLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXJTKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:10:58 -0400
Received: from mx1.suse.de ([195.135.220.2]:38553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbXJTKK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:10:57 -0400
Message-Id: <20071020100903.717837398@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Sat, 20 Oct 2007 12:09:03 +0200
From: Jan Blunck <jblunck@suse.de>
To: Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: [RFC 0/2] readdir() as an inode operation
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first try to move readdir() to become an inode operation. This is
necessary for a VFS implementation of "something like union-mounts" where a
readdir() needs to read the directory contents of multiple directories.
Besides that the new interface is no longer giving the struct file to the
filesystem implementations anymore.

Comments, please?
Jan

