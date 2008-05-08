Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYEHNyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYEHNyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYEHNyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:54:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:22719 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYEHNye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WzCiBmusm7ODtIlG7Can/7nbpWtBcUEAXV+FPXhqleo6pfkBFjB2We4vxMYTFRPszPSbpznbBWlM3WJfwtepTw2pzmgLf7ioF1Fd36NBwQPoYbJ/VqoD6wC2uQ20dZsoMWYuaJtikrWq9S0cHNj3OowoHFFmL9SBL9DdkHH9JFg=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: [Patch 0/9] Fix resource leaks for exec related stuffs
Date: Thu,  8 May 2008 21:52:25 +0800
Message-Id: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains various fixes for fs/binfmt_*.c, fs/{exec, compat}.c.
Most of them are aimed to fix resource leaks in failure path. Others
are bug fixes in failure path.

All patches are tested on UML, except [5/9] and [6/9], since I don't have
the desired environment to test them. It should be OK since [4/9] is the
similar fix.

Signed-off-by: WANG Cong <wangcong@zeuux.org>


