Return-Path: <linux-kernel-owner+w=401wt.eu-S934299AbXJRW0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299AbXJRW0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763270AbXJRWZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:25:46 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:34366 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761241AbXJRWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:25:44 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 0/5] TASK_KILLABLE
Date: Thu, 18 Oct 2007 18:25:57 -0400
Message-Id: <11927463623428-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches introduces the facility to deliver only fatal
signals to tasks which are otherwise waiting uninterruptibly.
