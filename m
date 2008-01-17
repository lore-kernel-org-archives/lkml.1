Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYAQOgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYAQOgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYAQOgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:36:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:51874 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYAQOgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:36:10 -0500
Message-ID: <478F67BF.4090409@windriver.com>
Date: Thu, 17 Jan 2008 08:35:43 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kgdb:unify x86-kgdb
References: <478F66F6.40107@siemens.com>
In-Reply-To: <478F66F6.40107@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2008 14:35:44.0182 (UTC) FILETIME=[3DD8A560:01C85916]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> diff -up arch/x86/kernel/kgdb_32.c arch/x86/kernel/kgdb_64.c
>
> screamed for unification. Here it is.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>
> ---
>  arch/x86/kernel/Makefile_32 |    2 
>  arch/x86/kernel/Makefile_64 |    2 
>  arch/x86/kernel/kgdb.c      |  561 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/kgdb_32.c   |  414 --------------------------------
>  arch/x86/kernel/kgdb_64.c   |  495 --------------------------------------
>  5 files changed, 563 insertions(+), 911 deletions(-)
>   
FYI this is already done in the head branch for kgdb which is going into
the -mm tree.  You will see the new patch set in the 2.6.25-rcX series.

There is now a single x86-lite.patch which contains a number of other
modifications to the core-lite.patch to make use of
probe_kernel_address() and a new function probe_kernel_write().  Also
the die hooks for the "no context" memory faults were removed.

Jason.
