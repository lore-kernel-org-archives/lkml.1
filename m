Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYL3XMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYL3XMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYL3XMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:12:31 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:34637 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbYL3XMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:12:31 -0500
From: Peter W Morreale <pmorreale@novell.com>
Subject: [PATCH 0/2] pdflush fix and enhancement
To: linux-kernel@vger.kernel.org
Date: Tue, 30 Dec 2008 16:12:29 -0700
Message-ID: <20081230231152.10427.50620.stgit@hermosa.site>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a fix for pdflush thread creation and an
enhancement for allowing the setting of the minimum and maximun number
of pdflush threads. 

These patches apply against 2.6.27.

Best,
-PWM

---

Peter W Morreale (2):
      Add /proc controls for pdflush threads
      Fix pdflush thread creation upper bound.


 include/linux/sysctl.h    |    2 ++
 include/linux/writeback.h |    2 ++
 kernel/sysctl.c           |   16 ++++++++++++++++
 mm/pdflush.c              |   42 +++++++++++++++++++++++++++++++++---------
 4 files changed, 53 insertions(+), 9 deletions(-)

