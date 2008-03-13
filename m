Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYCMNAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYCMNAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYCMM7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:59:47 -0400
Received: from styx.suse.cz ([82.119.242.94]:58575 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754402AbYCMM7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:59:45 -0400
Date: Thu, 13 Mar 2008 13:59:44 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH 0/4] Automatic quotaon on remount
Message-ID: <20080313125944.GF12523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  the series of patches below implements automatic enabling of quotas on
remount read-write when filesystem with quotas enabled has previously been
remounted read-only (and thus quotas had to be disabled).
  The patches are split logically, but due to interface changes all four
patches need to be applied together or ext3, ext4 or reiserfs won't
compile.

[PATCH 1/4] quota: Quota core changes for quotaon on remount
[PATCH 2/4] ext3: Make ext3 handle quotaon on remount
[PATCH 3/4] ext4: Make ext4 handle quotaon on remount
[PATCH 4/4] reiserfs: Make reiserfs handle quotaon on remount

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
