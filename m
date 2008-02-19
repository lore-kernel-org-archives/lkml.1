Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbYBSEOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbYBSEOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbYBSEMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:12:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:56589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbYBSEMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:12:21 -0500
Message-Id: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:35 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 00/11] possible debugfs/libfs consolidation
X-Provags-ID: V01U2FsdGVkX19gdtj9s0Tk+mgIwd64ef/x7A7bzQQjyPhC4i8
 VeOKCpsFgD2rDEFZg/NaE6jztgwRModDFnVnOkgcUDbSe33Oh9
 D78G04XeaAeY+lrTSJa7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that there is a lot of duplication in pseudo
file systems, so I started looking into how to consolidate
them. I ended up with a largish rework of the structure
of libfs and moving almost all of debugfs in there as well.

As an example, I also have patches that reduce debugfs,
securityfs and usbfs to the point where they are mostly
thin wrappers around libfs, with large comment blocks.
Other file systems could be changed in the same way, but
I first like to see if people agree that I'm on the right
track.

These patches have seen practically no testing so far,
so don't expect them to work, but please tell me what
you think about the concept.

	Arnd <><

