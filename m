Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZFKP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZFKP33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZFKP3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:29:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZFKP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:29:19 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dlm patches for 2.6.31
Date: Thu, 11 Jun 2009 10:20:45 -0500
Message-Id: <1244733649-26003-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the pending dlm patches for the 2.6.31 merge.  They have all been in
linux-next for quite a while, and are all minor changes/fixes.
Dave


 fs/dlm/dir.c          |    7 ++++---
 fs/dlm/lockspace.c    |   17 ++++++++---------
 fs/dlm/lowcomms.c     |   22 ++++++++++++++++++----
 fs/dlm/lowcomms.h     |    3 ++-
 fs/dlm/member.c       |   19 +++++++++++++------
 fs/dlm/requestqueue.c |    2 +-
 include/linux/dlm.h   |    4 ++--
 7 files changed, 48 insertions(+), 26 deletions(-)


Christine Caulfield (1):
      dlm: connect to nodes earlier

David Teigland (2):
      dlm: fix use count with multiple joins
      dlm: use more NOFS allocation

Geert Uytterhoeven (1):
      dlm: Make name input parameter of {,dlm_}new_lockspace() const

