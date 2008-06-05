Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYFEMmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYFEMmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbYFEMm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:42:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:57721 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757091AbYFEMm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:42:28 -0400
Date: Thu, 5 Jun 2008 14:42:26 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 0/2] New split of quota headers
Message-ID: <20080605124226.GF27370@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Andrew,

  after Adrian's comments and a bit of thinking, I've decided to split
quota headers differently which also solves the issue with new header file
which should be exported. I found out it is enough to move some functions
into quotaops.h where they logically also fit nicely. So please replace
my patches:
+ ext4-add-explicit-include-of-linux-quotah-into-ext4_jbd2h.patch
+ ext2-add-explicit-include-of-linux-quotah-into-superc.patch
+ quota-split-out-quota_structh-out-of-quotah.patch
+ quota-convert-macros-to-inline-functions.patch

with the two patches which will follow. Thanks and sorry for additional
work.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
