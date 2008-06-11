Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYFKAEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYFKAEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYFKAEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:04:15 -0400
Received: from kumera.dghda.com ([80.68.90.171]:3312 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbYFKAEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:04:13 -0400
From: "Duane Griffin" <duaneg@dghda.com>
To: akpm@linux-foundation.org
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
Subject: [PATCH 0/6][v2] ext{2,3,4}: tighten inheritance and setting of inode flags
Date: Wed, 11 Jun 2008 01:04:03 +0100
Message-Id: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series prevents inheritance and setting of various flags,
as appropriate for specific inode types. Flags which should be inherited
are listed explicitly so as to prevent future flags being overlooked and
inherited by accident. It introduces a function to mask flags based on
the inode type and uses it in inode creation and the SETFLAGS ioctl to
facilitate future consistency.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

This version introduces the restrictions on setting flags for
inappropriate inodes and lists inheritable flags explicitly.

Cheers,
Duane.
