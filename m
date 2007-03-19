Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbXCSTk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbXCSTk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbXCSTk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:40:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15141 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbXCSTkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:40:55 -0400
Date: Mon, 19 Mar 2007 12:40:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com
Subject: Re: 2.6.21-rc3-mm2
Message-Id: <20070319124007.4ab84e91.randy.dunlap@oracle.com>
In-Reply-To: <20070307201915.4d579113.akpm@linux-foundation.org>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
> 
> - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
>   were dropped.
> 
>   This is for A/B comparison purposes, and because those changes crashed on
>   one test setup.

with CONFIG_PROC_FS=n (x86_64):

  LD      .tmp_vmlinux1
kernel/built-in.o: In function `ptrace_start':
ptrace.c:(.text+0x300f9): undefined reference to `ptrace_may_attach'
make: *** [.tmp_vmlinux1] Error 1


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
