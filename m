Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZBJSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZBJSoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZBJSoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:44:07 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:56226 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZBJSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:44:05 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/3] trace: fix sparse warnings
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 19:43:47 +0100
Message-ID: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes some sparse warnings in kernel/trace.

---

Hannes Eder (3):
      trace: fix sparce warning: attribute function with __acquires/__releases
      trace: fix sparse warnings: fix (un-)signedness
      trace: fix sparse warnings: make symbols static


 kernel/trace/ring_buffer.c |    8 ++++----
 kernel/trace/trace.c       |   18 +++++++++++-------
 2 files changed, 15 insertions(+), 11 deletions(-)
