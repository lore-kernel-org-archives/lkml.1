Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbXFSN1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbXFSN1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbXFSN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:27:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:59798 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757867AbXFSN12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:27:28 -0400
Message-Id: <20070619132549.266927601@suse.cz>
User-Agent: quilt/0.46-42
Date: Tue, 19 Jun 2007 15:25:49 +0200
From: mmarek@suse.cz
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/3] Fix for XFS compat ioctls (try2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is my second attempt at fixing (some of) the XFS ioctls in compat mode.
The main difference from the first version is the bulkstat patch, which I
modified to do less copies (no unnecessary copy_in_user() anymore).

--
have a nice day,
Michal Marek

