Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZIBN73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZIBN73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZIBN71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:59:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbZIBN70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:26 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de
Subject: [PATCH 0/16] Make O_SYNC handling use standard syncing path (version 4)
Date: Wed,  2 Sep 2009 15:59:10 +0200
Message-Id: <1251899966-7316-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  here is a new version of my O_SYNC cleanup patches. There are two minor
changes since last time. XFS now uses filemap_write_and_wait() as Christoph
asked and generic syncing function has been renamed to vfs_fsync_range() and
the flags controling it are gone and it has just a single datasync flag as
other syncing functions.
  If noone objects, I think the patch series is ready to be put in linux-next.

								Honza
