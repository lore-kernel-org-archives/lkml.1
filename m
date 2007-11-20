Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbXKTBtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbXKTBtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXKTBsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:48:50 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2036 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbXKTBsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:50 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/59] trivial - Add missing "space" in multiline quoted strings
Date: Mon, 19 Nov 2007 17:47:52 -0800
Message-Id: <1195523331-15303-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: 1234567
References: 1234567
Message-Id: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix quoted string which do not have a space separating
the next word on continuation quoted strings.

for example:
    "a line with a word"
    "but no space"
is equivalent to:
    "a line with a wordbut no space"
which becomes:
    "a line with a word "
    "but no space"

Signed-off-by: Joe Perches <joe@perches.com>
