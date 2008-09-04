Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYIDQp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYIDQp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIDQpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:45:14 -0400
Received: from xenotime.net ([66.160.160.81]:55627 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752523AbYIDQpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:45:13 -0400
Date: Thu, 4 Sep 2008 09:45:10 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, arjan@infradead.org, arjan@linux.intel.com,
       mingo@elte.hu
Subject: Re: + fix-fastboot-make-the-raid-autodetect-code-wait-for-all-devices-to-init.patch
 added to -mm tree
In-Reply-To: <200809040539.m845dEgX022904@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809040941550.19666@shark.he.net>
References: <200809040539.m845dEgX022904@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, akpm@linux-foundation.org wrote:

> Subject: fix "fastboot: make the raid autodetect code wait for all devices to init"
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> : commit b52c36a95ed8026b6925fe8595ebcab6921ae62d
> : Author: Arjan van de Ven <arjan@linux.intel.com>
> : Date:   Sun Jul 20 13:07:09 2008 -0700
> :
> :     fastboot: make the raid autodetect code wait for all devices to init
> 
> init/do_mounts_md.c: In function `md_run_setup':
> init/do_mounts_md.c:282: warning: ISO C90 forbids mixed declarations and code
> 
> How did this happen?

There are so many warnings that they get lost in the noise
unless someone is actively looking for them.

If I modify a source file, I try to check its build status afterwards
and not just that the kernel build succeeded.

-- 
~Randy
