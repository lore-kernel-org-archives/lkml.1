Return-Path: <linux-kernel-owner+w=401wt.eu-S965316AbXCFQjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316AbXCFQjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965317AbXCFQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:39:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:45152 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965316AbXCFQjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:39:41 -0500
Date: Tue, 6 Mar 2007 17:44:47 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, akpm@osdl.org
Subject: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070306164447.GC3661@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  the patches attached to six following emails implement some cleanup and
fixes in the UDF code. The main two fixes are:
  1) UDF now works correctly for files larger than 1GB.
  2) Deleting a directory updates number of links to the parent directory
     correctly.
See headers of following patches for details.

The patches sustained some torturing so I hope that I did not introduce
more bugs than I've fixed ;).  Andrew, could you please put the patches
into -mm kernels for testing?  Thanks.

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
