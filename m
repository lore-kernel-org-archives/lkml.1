Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYKXPky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYKXPky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYKXPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:40:18 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:9912 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYKXPkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:40:17 -0500
From: Andrey Mirkin <major@openvz.org>
To: orenl@cs.columbia.edu, containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andrey Mirkin <major@openvz.org>
Subject: [PATCH 0/2] In-kernel process restart
Date: Mon, 24 Nov 2008 18:39:33 +0300
Message-Id: <1227541175-30301-1-git-send-email-major@openvz.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patchset introduces OpenVZ kernel based restart procedure on top of
Oren's checkpoint/restart patchset v9.

For restarting a set of processes one will need to call sys_restart() once with
new flag CR_CTX_RSTR_IN_KERNEL. All work will be done in kernel in this case.

Small changes to image format are required to make in-kernel process creation
more easy.

Oren, please take a look on this patchset. I've tried to port OpenVZ
functionality on top of yours with minimal changes.
