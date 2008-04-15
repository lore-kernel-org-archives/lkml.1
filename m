Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYDOALr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYDOALr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 20:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbYDOALh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 20:11:37 -0400
Received: from tamago.serverit.net ([91.189.209.155]:36619 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756025AbYDOALg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 20:11:36 -0400
Date: Tue, 15 Apr 2008 03:11:27 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Miklos Szeredi <miklos@szeredi.hu>
cc: dwmw2@infradead.org, hch@infradead.org, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <10224488.783261208172602425.JavaMail.szaka@kolumbus.fi>
Message-ID: <Pine.LNX.4.62.0804150102280.10583@tamago.serverit.net>
References: <10224488.783261208172602425.JavaMail.szaka@kolumbus.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Apr 2008 Miklos Szeredi wrote:

> I don't claim fuse has a great part in it, 

Yep, actually it's me who claims that without FUSE there wouldn't be today 
open source read/write NTFS driver for Linux, FreeBSD, NetBSD, OS X, 
Solaris, etc in a pretty short time developed as a spare time hobby (the 
estimated development cost of the Microsoft NTFS driver is $20-30 million). 
Quite many people contributed significantly in the last twelve years but 
the breakthrough came via FUSE.

Probably FUSE is the most significant innovation Linux ever contributed to 
computer science in the file system area. I think the hundreds of FUSE file 
systems and the happy __users__ on all the FUSE platforms justify this, who 
absolutely don't care if it's a kernel, user, hibrid, or mikrospace driver.

> except the obvious advantages of developing in userspace: no kernel 
> crashes, easier debugging, etc...

In my experience the huge difference is for users getting better quality 
and faster support. It takes from several months to many years to get new 
features and fixes to millions of user via kernel drivers but it takes a 
matter of hours/days via user space binaries. This results a much faster, 
quality and feature efficient release cycle.

The kernel part is indeed always the most problematic because fixes and new 
things take very long time to arrive to end users. Some longstanding major 
issues:

  - asynchronous unmount. It was solved within days in August of 2006,
    still a problem for users.

  - USB powering down/up problems with some popular external USB drives. 
    People are loosing data because of this since a year. 

  - sync(2) is not syncing

  - recent kernels ignore file permissions
    
  - large block support

  - non-aligned async writes are converted to sync reads

  - ARM 50x context switch speed up patch not used 


	Szaka

--
NTFS-3G:  http://ntfs-3g.org

