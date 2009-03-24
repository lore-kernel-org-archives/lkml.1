Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbZCXOSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbZCXOSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbZCXOLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:11:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760771AbZCXOLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:46 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] dlm patches for 2.6.30
Date: Tue, 24 Mar 2009 09:07:45 -0500
Message-Id: <1237903672-18913-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the pending dlm patches for the 2.6.30 merge.  They have all been in
linux-next for quite a while.  The notable fixes come from using the dlm with
ocfs2 and relate to handling lock cancelation and large nodeids.
Dave


 fs/dlm/dir.c          |   18 +++---
 fs/dlm/dlm_internal.h |    2 +-
 fs/dlm/lock.c         |   60 ++++++++++++++--
 fs/dlm/lockspace.c    |    2 +-
 fs/dlm/lowcomms.c     |  181 ++++++++++++++++++++++++++-----------------------
 fs/dlm/user.c         |   24 ++++---
 6 files changed, 175 insertions(+), 112 deletions(-)


Christine Caulfield (1):
      dlm: replace idr with hash table for connections

David Teigland (3):
      dlm: clear defunct cancel state
      dlm: ignore cancel on granted lock
      dlm: fix length calculation in compat code

Joe Perches (2):
      dlm: use ipv6_addr_copy
      dlm: comment typo fixes

Steven Whitehouse (1):
      dlm: Change rwlock which is only used in write mode to a spinlock

