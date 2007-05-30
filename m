Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbXE3Oay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbXE3Oay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbXE3Oap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:30:45 -0400
Received: from styx.suse.cz ([82.119.242.94]:36508 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751925AbXE3Oao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:30:44 -0400
Message-Id: <20070530125954.706423971@suse.cz>
User-Agent: quilt/0.46-36
Date: Wed, 30 May 2007 14:59:54 +0200
From: Michal Marek <mmarek@suse.cz>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/3] Fix for XFS compat ioctls
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it looks like the XFS compat ioctl interface
(fs/xfs/linux-2.6/xfs_ioctl32.c) is quite incomplete. Attached patches
fix some ioctls to make at least xfsdump work. Tested on x86_64 with an
i386 xfsdump binary, I'll test on ppc64 later.

-- 
have a nice day,
Michal Marek
