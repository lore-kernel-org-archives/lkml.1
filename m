Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbXFDL5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbXFDL5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXFDL5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:57:00 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:55212 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752938AbXFDL47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:56:59 -0400
Date: Mon, 4 Jun 2007 13:56:57 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: apic related BUG: soft lockup detected on CPU#0!
Message-ID: <20070604115657.GA12941@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI,

2.6.21.1, tainted with ATI fglrx driver (so maybe take it with a grain
of salt):

When I attempted to kill -9 an unresponsive looping X server (desktop
processes were gone at that time) the system locked up and reported
the following:

BUG: soft lockup detected on CPU#0!
 [<c01054a9>] show_trace_log_lvl+0x19/0x30
 [<c01054d2>] show_trace+0x12/0x20
 [<c01055d4>] dump_stack+0x14/0x20
 [<c014a7a2>] softlockup_tick+0xa2/0xc0
 [<c012bf02>] run_local_timers+0x12/0x20
 [<c012bd1d>] update_process_times+0x5d/0x90
 [<c013d91f>] tick_sched_timer+0x4f/0xb0
 [<c01393f7>] hrtimer_interrupt+0x177/0x1e0
 [<c010fb07>] local_apic_timer_interrupt+0x57/0x60
 [<c010fb33>] smp_apic_timer_interrupt+0x23/0x40
 [<c0105158>] apic_timer_interrupt+0x28/0x30
 =======================

-- 
Frank
