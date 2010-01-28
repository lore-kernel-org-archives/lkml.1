Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644Ab0A1BOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0A1BOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359Ab0A1BOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:14:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab0A1BOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:14:00 -0500
Date: Wed, 27 Jan 2010 17:13:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] core: posix-cpu-timers, cleanup rlimits usage
Message-Id: <20100127171335.7edf041d.akpm@linux-foundation.org>
In-Reply-To: <1264610071-24794-1-git-send-email-jslaby@suse.cz>
References: <1264610071-24794-1-git-send-email-jslaby@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 17:34:30 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> Fetch rlimit (both hard and soft) values only once and work on them.
> It removes many accesses through sig structure and makes the code
> cleaner.

The patch doesn't apply for me in semi-serious ways because I applied
rather a lot of timer-related patches:

timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-add-suspend-callback.patch
posix-timersc-dont-export-local-functions.patch
timers-introduce-the-concept-of-timer-slack-for-legacy-timers.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch


(The above patches are up to six months old.  Something isn't working right).
