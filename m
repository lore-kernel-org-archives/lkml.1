Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYBWMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYBWMeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYBWMd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:33:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33961 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYBWMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:33:56 -0500
Date: Sat, 23 Feb 2008 12:33:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC 01/11] add generic versions of debugfs file operations
Message-ID: <20080223123355.GO27894@ZenIV.linux.org.uk>
References: <20080219040435.825494460@arndb.de> <20080219040828.415218298@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219040828.415218298@arndb.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:04:36AM +0100, Arnd Bergmann wrote:
> The file operations in debugfs are rather generic and can
> be used by other file systems, so it can be interesting to
> include them in libfs, with more generic names, and exported
> to modules.
> 
> This patch adds a new copy of these operations to libfs,
> so that the debugfs version can later be cut down.

BTW, where does CONFIG_LIBFS come from?
