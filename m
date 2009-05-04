Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZEDMP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZEDMP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZEDMPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:15:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55357 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZEDMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:15:47 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 7/7] kconfig: search for a config to base the local(mod|yes)config on
From: Andi Kleen <andi@firstfloor.org>
References: <20090430185022.122124349@goodmis.org>
	<20090430185223.792841532@goodmis.org>
Date: Mon, 04 May 2009 14:15:41 +0200
In-Reply-To: <20090430185223.792841532@goodmis.org> (Steven Rostedt's message of "Thu, 30 Apr 2009 14:50:29 -0400")
Message-ID: <87fxflgj2q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> Here's the list and order of search:
>
>   /proc/config.gz
>   /boot/vmlinuz-`uname -r`
>   vmlinux  # local to the directory
>   /lib/modules/`uname -r`/kernel/kernel/configs.ko
>   kernel/configs.ko
>   kernel/configs.o
>   .config


That seems like the wrong order. ./.config should always be first for
compatibility. 

That order would completely wreck all my build scripts, and I suspect
others too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
