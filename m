Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbZFMAzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbZFMAzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZFMAzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:55:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58664 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZFMAzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:55:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Blackfin fbdev fixes for 2.6.31
Date: Fri, 12 Jun 2009 20:55:31 -0400
Message-Id: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew: could you pick these up ?  unless i missed something, there isnt a
tree for fbdev drivers, just the fb layer.  these were posted to the fbdev
mailing list already.

Mike Frysinger (4):
  fbdev: Blackfin has __raw I/O accessors, so use them in fb.h
  fbdev: bfin-t350mcqb-fb: drop unused local variables
  fbdev: *bfin*: fix __dev{init,exit} markings
  fbdev: bf54x-lq043fb: use kzalloc over kmalloc/memset

Vivek Kutal (1):
  fbdev: *bfin*: drop unnecessary calls to memset

 drivers/video/bf54x-lq043fb.c    |   15 +++++----------
 drivers/video/bfin-t350mcqb-fb.c |   15 +++------------
 include/linux/fb.h               |    2 +-
 3 files changed, 9 insertions(+), 23 deletions(-)

