Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYDUUYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYDUUYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYDUUYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:24:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:60766 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYDUUYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:24:00 -0400
Message-ID: <480CF7E0.8060906@windriver.com>
Date: Mon, 21 Apr 2008 15:24:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kgdb: fix signedness mixmatches, add statics, add	declaration
 to header
References: <1208544691.17196.48.camel@brick>
In-Reply-To: <1208544691.17196.48.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 20:23:48.0790 (UTC) FILETIME=[9B492D60:01C8A3ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Noticed by sparse:
> arch/x86/kernel/kgdb.c:556:15: warning: symbol 'kgdb_arch_pc' was not declared. Should it be static?
> kernel/kgdb.c:149:8: warning: symbol 'kgdb_do_roundup' was not declared. Should it be static?
> kernel/kgdb.c:193:22: warning: symbol 'kgdb_arch_pc' was not declared. Should it be static?
> kernel/kgdb.c:712:5: warning: symbol 'remove_all_break' was not declared. Should it be static?
>
> Related to kgdb_hex2long:
> arch/x86/kernel/kgdb.c:371:28: warning: incorrect type in argument 2 (different signedness)
> arch/x86/kernel/kgdb.c:371:28:    expected long *long_val
> arch/x86/kernel/kgdb.c:371:28:    got unsigned long *<noident>
> kernel/kgdb.c:469:27: warning: incorrect type in argument 2 (different signedness)
> kernel/kgdb.c:469:27:    expected long *long_val
> kernel/kgdb.c:469:27:    got unsigned long *<noident>
> kernel/kgdb.c:470:27: warning: incorrect type in argument 2 (different signedness)
> kernel/kgdb.c:470:27:    expected long *long_val
> kernel/kgdb.c:470:27:    got unsigned long *<noident>
> kernel/kgdb.c:894:27: warning: incorrect type in argument 2 (different signedness)
> kernel/kgdb.c:894:27:    expected long *long_val
> kernel/kgdb.c:894:27:    got unsigned long *<noident>
> kernel/kgdb.c:895:27: warning: incorrect type in argument 2 (different signedness)
> kernel/kgdb.c:895:27:    expected long *long_val
> kernel/kgdb.c:895:27:    got unsigned long *<noident>
> kernel/kgdb.c:1127:28: warning: incorrect type in argument 2 (different signedness)
> kernel/kgdb.c:1127:28:    expected long *long_val
> kernel/kgdb.c:1127:28:    got unsigned long *<noident>
> kernel/kgdb.c:1132:25: warning: incorrect type in argument 2 (different signedness)
> kernel/kgdb.c:1132:25:    expected long *long_val
> kernel/kgdb.c:1132:25:    got unsigned long *<noident>
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>   

This patch looked fine Harvey, I queued it for the next pull request at:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_linus

Jason.


