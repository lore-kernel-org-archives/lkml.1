Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYDLXB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYDLXB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbYDLW7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:59:05 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35379 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYDLW6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:58:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/7] OMFS filesystem version 3
Date: Sat, 12 Apr 2008 18:58:34 -0400
Message-Id: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Andrew, perhaps this could bake in -mm for a cycle or two if 
there are no objections?)

These patches 1-7 add the Optimized MPEG Filesystem, a proprietary
filesystem used by the embedded devices Rio Karma and ReplayTV 
which are no longer manufactured.

I've been maintaining this reverse-engineered filesystem
out-of-tree since around 2.6.12.  It has stabilized to the point
that, while not quite feature-complete, it is close enough that
I'm pretty much just applying VFS API updates to it these days.
So, in the spirit of stable_api_nonsense, I request that it be
considered for inclusion for .26 or later.  

There is a small user community (<20?) using the driver today.
According to google, it has been packaged by others for Debian,
Ubuntu, and Mandriva.

I have also written an implementation in FUSE.  However, in
its current unoptimized state, the FUSE version is about half the 
speed of the kernel driver.  Either way, the kernel version could 
use a review given some distros have apparently picked it up.

version 3:
 - fixed sparse warnings
 - added more sanity checking in list traversals

version 2:
 - removed private inode cache 
 - included GPL v2 notice
 - rewrote omfs_count_free to use hamming weight library functions 
 - removed duplicated crc-itu-t

Version 1: initial post

