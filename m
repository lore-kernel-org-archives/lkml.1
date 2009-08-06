Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZHFCnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZHFCnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZHFCnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:43:49 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3232 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZHFCnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:43:49 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 0/7] scripts/get_maintainer.pl: New features
Date: Wed,  5 Aug 2009 19:43:41 -0700
Message-Id: <cover.1249525834.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few improvements that a couple of people requested.

Joe Perches (7):
  scripts/get_maintainer.pl: Add --git-blame
  scripts/get_maintainer.pl: Add sections in pattern match depth order
  scripts/get_maintainer.pl: Add --pattern-depth
  scripts/get_maintainer.pl: Better email routines, use perl not shell where possible
  scripts/get_maintainer.pl: Add .mailmap use, shell and email cleanups
  scripts/get_maintainer.pl: Using --separator implies --nomultiline
  scripts/get_maintainer.pl: Add --remove-duplicates

 scripts/get_maintainer.pl |  361 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 280 insertions(+), 81 deletions(-)

