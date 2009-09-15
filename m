Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZIONYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZIONYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZIONYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:24:46 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62887 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZIONYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:24:46 -0400
To: linux-kernel@vger.kernel.org
Subject: Zero and NULL in INIT_TASK()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200909152224.DAC35901.FFLOJFOHtSOVQM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 15 Sep 2009 22:24:47 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that INIT_TASK() macro is used for initializing only statically
allocated init_task, which will be automatically initialized to 0.
If so, can't we omit initialization with zero and NULLs inside INIT_TASK()?
