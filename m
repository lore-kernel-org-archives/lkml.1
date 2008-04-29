Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbYD2TAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbYD2TAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYD2S7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:59:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59268 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYD2S7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:59:48 -0400
Subject: [RFC][PATCH 0/5] do remounts without consulting sb->s_files list
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       trond.myklebust@fys.uio.no, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2008 11:59:43 -0700
Message-Id: <20080429185943.3BA6A050@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements the ability to check a superblock
for writers without consulting the sb->s_files list.  This
is on Al and Christoph's wishlist as something that can
happen now that we have r/o bind mounts merged.

Trond, I'm ccing you because there is some minor NFS
touching going on here.

-- Dave
