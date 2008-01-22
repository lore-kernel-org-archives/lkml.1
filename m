Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbYAVXVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbYAVXVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbYAVXV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:21:27 -0500
Received: from smtp02.mtu.ru ([62.5.255.49]:63015 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbYAVXVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:21:25 -0500
From: Anton Salikhmetov <salikhmetov@gmail.com>
To: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
Subject: [PATCH -v8 0/4] Fixing the issue with memory-mapped file times
Date: Wed, 23 Jan 2008 02:21:16 +0300
Message-Id: <12010440803930-git-send-email-salikhmetov@gmail.com>
X-Mailer: git-send-email 1.4.4.4
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the eighth version of my solution for the bug #2645:

http://bugzilla.kernel.org/show_bug.cgi?id=2645

Since the previous version, the following has changed:

1) based on Linus' comment, a more efficient PTE walker implemented;

2) the design document added to the kernel documentation.

Functional tests successfully passed.

Please comment.
