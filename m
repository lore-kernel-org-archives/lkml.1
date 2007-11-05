Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbXKECPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbXKECPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXKECOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:14:55 -0500
Received: from [222.73.24.84] ([222.73.24.84]:51383 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXKECOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:14:54 -0500
Message-ID: <472E7C2C.3030205@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 10:13:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] fix memset size error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of six proposed patches fix the same kind of bug. The size
passing to memset is the size of a pointer i.e. sizeof(ptr), and normally
the right thing is sizeof(*ptr).


Li Zefan
