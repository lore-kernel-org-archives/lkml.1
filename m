Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbXEYDEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbXEYDEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXEYDEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:04:24 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:42316 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbXEYDEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:04:23 -0400
Message-ID: <46565237.6010708@alcatel-lucent.com>
Date: Fri, 25 May 2007 11:04:23 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel crash in timer interrupt handler
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>	 <20070524102702.bca37396.akpm@linux-foundation.org>	 <m1r6p6dn3x.fsf@ebiederm.dsl.xmission.com>	 <20070524205900.GC14083@beardog.cca.cpqcorp.net>	 <m1hcq2dj5m.fsf_-_@ebiederm.dsl.xmission.com> <1180060356.8203.26.camel@concordia.ozlabs.ibm.com>
In-Reply-To: <1180060356.8203.26.camel@concordia.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 03:03:32.0513 (UTC) FILETIME=[47242110:01C79E79]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The kernel crashed inside timer handler. Anyone has ideas? The Linux I'm 
using is 2.6.19. Thanks in advance!

BUG: soft lockup detected on CPU#0!

Call Trace:

[C0395EA0] [C000C308] show_stack+0x58/0x180 (unreliable)

[C0395ED0] [C0043A18] softlockup_tick+0xac/0xc8

[C0395EF0] [C00223C4] run_local_timers+0x18/0x28

[C0395F00] [C0022414] update_process_times+0x40/0x7c

[C0395F10] [C0005800] timer_interrupt+0x70/0x208

[C0395F40] [C0004874] ret_from_except+0x0/0x14
