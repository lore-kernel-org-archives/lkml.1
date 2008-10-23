Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYJWSyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYJWSyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYJWSyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:54:38 -0400
Received: from broadrack.ru ([195.178.208.66]:40737 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYJWSyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:54:37 -0400
Date: Thu, 23 Oct 2008 22:54:35 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: [0/3] POHMELFS: the new release. Extended attributes.
Message-ID: <20081023185435.GA18461@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm pleased to announce the new POHMELFS release.

Short changelog:
 * Extended attributes.
 * Distributed locks for metadata updates.
 * Bug fixes and cleanups ( i n c l u d i n g w h i t e s p a c e s ! ).

POHMELFS is a very high performance parallel network filesystem with
local coherent cache of data and metadata. Its main goal is distributed
processing of the data.

Features supported by POHMELFS:
 * Locally coherent cache for data and metadata with (potentially) byte-range locks.
 	Since all Linux filesystems lock the whole inode during writing, algorithm
	is very simlpe and does not use byte-ranges, although they are sent in
	locking messages.
 * Completely async processing of all events (hard and symlinks are the
	only exceptions) including object creation and data reading and
	writing.
 * Flexible object architecture optimized for network processing. Ability
	to create long pathes to object and remove arbitrary huge 
	directories in single network command.
 * High performance is one of the main design goals.
 * Very fast and scalable multithreaded userspace server. Being in
	userspace it works with any underlying filesystem and still is much
	faster than async in-kernel NFS one.
 * Transactions support. Full failover for all operations. Resending
	transactions to different servers on timeout or error.
 * Client is able to switch between different servers (if one goes down,
	client automatically reconnects to second and so on).
 * Client parallel extensions: ability to write to multiple servers and
	balance reading between them.
 * Client dynamical server reconfiguration: ability to add/remove servers
	from working set in run-time.
 * Strong authentification and possible data encryption in network channel.
 * Extended attributes support.

POHMELFS roadmap now includes distributed and parallel facilities of the
server.

1. POHMELFS homepage.
http://www.ioremap.net/node/21

2. POHMELFS archive.
http://www.ioremap.net/archive/pohmelfs/

3. GIT trees.
http://www.ioremap.net/cgi-bin/gitweb.cgi

4. Development status.
http://www.ioremap.net/taxonomy/term/4

-- 
	Evgeniy Polyakov
