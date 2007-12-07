Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXLGKiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXLGKiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXLGKhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:37:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:51894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbXLGKht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:37:49 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Ingo Molnar <mingo@elte.hu>,
       Robert Love <rml@tech9.net>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
From: Andi Kleen <andi@firstfloor.org>
References: <20071207021952.6f0ac922@morte>
	<alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
Date: Fri, 07 Dec 2007 11:37:47 +0100
In-Reply-To: <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain> (Thomas Gleixner's message of "Fri\, 7 Dec 2007 06\:51\:55 +0100 \(CET\)")
Message-ID: <p737ijqkcxw.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
>
> Hmrpf. sched_clock() is used for the time stamp of the printks. We
> need to find some better solution other than killing off the tsc
> access completely.

Doing it properly requires pretty much most of my old sched-clock ff patch.
Complicated and not pretty, but ..
Unfortunately that version still had some jumps on cpufreq, but they
are fixable there.

-Andi
