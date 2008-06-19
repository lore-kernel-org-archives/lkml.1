Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYFSPm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYFSPm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYFSPmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:42:12 -0400
Received: from kumera.dghda.com ([80.68.90.171]:1486 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbYFSPmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:42:11 -0400
From: "Duane Griffin" <duaneg@dghda.com>
To: akpm@linux-foundation.org
Cc: Andreas Dilger <adilger@sun.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6][v3] ext{2,3,4}: tighten inheritance and setting of inode flags
Date: Thu, 19 Jun 2008 16:41:59 +0100
Message-Id: <1213890125-20186-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.4.5
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

This version fixes the types for the mask function.

Cheers,
Duane
