Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZDOFKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZDOFKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZDOFJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:09:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:39327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZDOFJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:09:53 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 0/7] Cleanup code that think bio_alloc with __GFP_WAIT can fail
Date: Wed, 15 Apr 2009 10:34:51 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, adilger@sun.com, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151034.52750.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_alloc will not fail when __GFP_WAIT is specified in the gfp_flags. See 
http://lkml.org/lkml/2009/4/14/198 for the discussion. But this not documented 
and there are places where there is unwanted code to handle bio_alloc failure 
even when __GFP_WAIT is specified. This patch set documents this and cleans up 
various callers who assume bio_alloc can fail even with __GFP_WAIT.

Thanks
Nikanth
