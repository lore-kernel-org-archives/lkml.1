Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965845Ab0BZTRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:17:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965816Ab0BZTRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:17:47 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dlm patches for 2.6.34
Date: Fri, 26 Feb 2010 13:17:40 -0600
Message-Id: <1267211864-5474-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Reposting the dlm patches for the 2.6.34 merge.  The patch "dlm: send
reply before bast" is expanded slightly to cover the cancel and unlock
cases the same way that convert and request have been fixed.  There's a
fourth patch added that makes the debugfs bast mode more useful for
debugging these conditions.


 fs/dlm/ast.c          |   74 +++++++++++++++++++++++-------
 fs/dlm/ast.h          |    4 +-
 fs/dlm/debug_fs.c     |    2 +-
 fs/dlm/dlm_internal.h |   10 +++-
 fs/dlm/lock.c         |  120 ++++++++++++++++++++++++++++++++++++------------
 fs/dlm/lockspace.c    |   14 +++++-
 fs/dlm/user.c         |   10 +++--
 fs/dlm/user.h         |    4 +-
 8 files changed, 180 insertions(+), 58 deletions(-)


David Teigland (3):
      dlm: fix ordering of bast and cast
      dlm: send reply before bast
      dlm: use bastmode in debugfs output

Steven Whitehouse (1):
      dlm: Send lockspace name with uevents

