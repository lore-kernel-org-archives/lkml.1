Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYDRQsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYDRQsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYDRQsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:48:02 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19546 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbYDRQsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:48:01 -0400
Date: Fri, 18 Apr 2008 09:45:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo <mingo@redhat.com>
Subject: Re: 2.6.25-mm1 (build error: trace selftest)
Message-Id: <20080418094548.2ae8ca8b.randy.dunlap@oracle.com>
In-Reply-To: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 01:47:57 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 


with CONFIG_RT_MUTEXES=N:

In file included from linux-2.6.25-mm1/kernel/trace/trace.c:2432:
linux-2.6.25-mm1/kernel/trace/trace_selftest.c: In function 'trace_wakeup_test_thread':
linux-2.6.25-mm1/kernel/trace/trace_selftest.c:413: error: implicit declaration of function 'rt_mutex_setprio'
make[3]: *** [kernel/trace/trace.o] Error 1

---
~Randy
