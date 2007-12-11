Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbXLKKP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbXLKKP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 05:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXLKKPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 05:15:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33131
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbXLKKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:15:50 -0500
Date: Tue, 11 Dec 2007 02:15:49 -0800 (PST)
Message-Id: <20071211.021549.126640032.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1: undefined reference to `compat_sys_timerfd' on
 sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071207160800.77e7e907.akpm@linux-foundation.org>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<200712080104.55619.m.kozlowski@tuxland.pl>
	<20071207160800.77e7e907.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 7 Dec 2007 16:08:00 -0800

> Or should this have been sys_nis_syscall()?

sys_nis_syscall() was used in cases on sparc where we wanted
to get a log of invocations of unimplemented syscalls, as it
aided debugging and anaylsis.

But the usefulness of such things I think is long gone, so
what I'll likely do is kill the sys_nis_syscall stuff from the
sparc ports.
