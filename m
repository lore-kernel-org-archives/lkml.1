Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYB0UOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYB0UOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYB0UOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:14:33 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:27381 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbYB0UOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:14:32 -0500
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
X-Message-Flag: Warning: May contain useful information
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
	<Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 12:14:24 -0800
In-Reply-To: <Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com> (Davide Libenzi's message of "Wed, 27 Feb 2008 11:41:24 -0800 (PST)")
Message-ID: <adabq62yx5r.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 20:14:25.0480 (UTC) FILETIME=[59386480:01C8797D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > The anonymous inodes interface anon_inode_getfd() calls fd_install()
 > > for the newly created fd, which does not work for some use cases where
 > > the caller must do futher initialization before exposing the file to
 > > userspace.  This is also probably not the safest interface, since the
 > > caller must be sure that it is OK if userspace closes the fd before
 > > anon_inode_getfd() even returns.
 > 
 > I believe Al changed the interface to not give out inode* and file*, *and* 
 > call fd_install() inside it. I'd slightly prefer Al version, although I 
 > don't see any major problems in this one too.

Any pointer to that patch?  A web search for "viro" and
"anon_inode_getfd" doesn't turn up anything likely looking.

 - R.
