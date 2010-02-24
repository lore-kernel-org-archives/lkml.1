Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0BXUjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:39:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910Ab0BXUj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:39:29 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] dlm patches for 2.6.34
Date: Wed, 24 Feb 2010 14:39:15 -0600
Message-Id: <1267043958-31082-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the dlm patches from -next for the 2.6.34 merge.
Dave


 fs/dlm/ast.c          |   74 ++++++++++++++++++++++++++++++++++++++----------
 fs/dlm/ast.h          |    4 +-
 fs/dlm/dlm_internal.h |   10 +++++-
 fs/dlm/lock.c         |   73 +++++++++++++++++++++++++++++++++++------------
 fs/dlm/lockspace.c    |   14 ++++++++-
 fs/dlm/user.c         |   10 ++++--
 fs/dlm/user.h         |    4 +-
 7 files changed, 143 insertions(+), 46 deletions(-)


David Teigland (2):
      dlm: fix ordering of bast and cast
      dlm: send reply before bast

Steven Whitehouse (1):
      dlm: Send lockspace name with uevents

