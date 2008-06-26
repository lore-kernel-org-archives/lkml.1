Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbYFZSMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbYFZSMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYFZSMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:12:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:48202 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYFZSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BMFeA5hNprvW4Q8QF0249DSNJ4+m294cTW7kFp6sZNDf9PqWq1GRBvx8DyWQv8jrrC
         s6zcEoah3n8zjjvtrYO1ar5JgXqEY9K31ixeVCPllt8tMUcY6l8/yHqiLD36UpV9P8Rs
         u5vpND0yuGuIXze90Wm5P0GxJ/h++88k+8t0s=
Message-ID: <a4423d670806261112n3a5073dcn476f0a3da963aa36@mail.gmail.com>
Date: Thu, 26 Jun 2008 22:12:34 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       "kernel list" <linux-kernel@vger.kernel.org>, hch@infradead.org,
       tes@sgi.com, lachlan@sgi.com
Subject: next-20080626: compiling error in XFS
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

  CC      fs/xfs/linux-2.6/xfs_xattr.o
fs/xfs/linux-2.6/xfs_xattr.c: In function 'xfs_decode_acl':
fs/xfs/linux-2.6/xfs_xattr.c:40: error: '_ACL_TYPE_ACCESS' undeclared
(first use in this function)
fs/xfs/linux-2.6/xfs_xattr.c:40: error: (Each undeclared identifier is
reported only once
fs/xfs/linux-2.6/xfs_xattr.c:40: error: for each function it appears in.)
fs/xfs/linux-2.6/xfs_xattr.c:42: error: '_ACL_TYPE_DEFAULT' undeclared
(first use in this function)


CONFIG_XFS_POSIX_ACL is disabled, so _ACL_TYPE_ACCESS was not defined.
