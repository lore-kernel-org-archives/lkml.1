Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZGIFqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZGIFqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZGIFqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:46:40 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4615 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZGIFqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:46:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/2] get_maintainer improvements
Date: Wed,  8 Jul 2009 22:46:36 -0700
Message-Id: <cover.1247117932.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann pointed out that the directory pattern trailing slash
requirement is unnecessary and error prone.  He also sent a patch to
fix it which I've modified a bit.

Andrew Morton wanted the ability to use -f directory.  Added it.

Joe Perches (2):
  scripts/get_maintainer.pl: Add -f directory use
  MAINTAINERS: Remove directory trailing slash pattern requirement

 MAINTAINERS               |    9 ++++-----
 scripts/get_maintainer.pl |   23 +++++++++++++++++++----
 2 files changed, 23 insertions(+), 9 deletions(-)

