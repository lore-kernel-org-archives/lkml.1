Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbYLDGkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbYLDGkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYLDGkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:40:00 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50175 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbYLDGj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:39:59 -0500
Date: Wed, 03 Dec 2008 23:39:54 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/6][REPOST] ext{2,3,4}: tighten inheritance and	setting of
 inode flags
In-reply-to: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: akpm@linux-foundation.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20081204063954.GG3186@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 03, 2008  19:54 +0000, Duane Griffin wrote:
> This patch series prevents the inheritance and setting of flags that are
> inappropriate for specific inode types.
> 
> Flags which should be inherited are listed explicitly so as to prevent
> future flags being overlooked and inherited by accident.
> 
> It introduces a function to mask flags based on the inode type and uses
> it in inode creation and the SETFLAGS ioctl to help prevent future
> inconsistency.
> 
> Patches 1-3 fix the TOPDIR flag inheritance bug reported at
> http://bugzilla.kernel.org/show_bug.cgi?id=9866.
> 
> Patches 4-6 fix a related problem with non-regular file/dir inodes
> inheriting inappropriate flags, discovered while testing. For example,
> on an unpatched system, the following sequence will create an
> un(re)movable device node:

I worked with Duane during the development of these patches and agree
that they implement the proper solution to a problem that has repeated
a number of times as new flags are added.

Acked-by: Andreas Dilger <adilger@sun.com>

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

