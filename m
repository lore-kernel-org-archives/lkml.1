Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZC0NCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZC0NCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZC0NCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:02:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41978 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZC0NCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:02:45 -0400
Date: Fri, 27 Mar 2009 13:02:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Larsson <alexl@redhat.com>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Issues with using fanotify for a filesystem indexer
Message-ID: <20090327130242.GW28946@ZenIV.linux.org.uk>
References: <1238158043.23703.20.camel@fatty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238158043.23703.20.camel@fatty>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 01:47:23PM +0100, Alexander Larsson wrote:

> In order to write an app using the fanotify API satisfying the above
> needs we would need the following events:
> * the event queue overflowed, (you need to reindex everything)
> * An inode was linked into the filesystem (creat, O_CREAT,
> mkdir, link, symlink, etc)
> * An inode was unlinked (unlink, rmdir, rename replaced existing file)
> * An inode was moved in the filesystem (rename)

Erm...  Just how would you represent and *order* the events?  Note that
"serialize all directory operations on given fs" is a non-starter...
