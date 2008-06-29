Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbYF2OrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbYF2OrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760495AbYF2Oqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:46:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41644 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760366AbYF2Oqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:46:46 -0400
Date: Sun, 29 Jun 2008 18:49:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] workqueues: flush_work()
Message-ID: <20080629144924.GA4341@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-send.

flush_work() was changed to check !list_empty() first. This doesn't
matter currently, but this is more correct for flush_work_sync().

The first patch is preparation, but imho makes sense by itself as
a cleanup and microoptimization.

Oleg.

