Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbYAaK4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbYAaK4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764758AbYAaKzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:55:54 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:49401 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764531AbYAaKzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:55:53 -0500
Date: Thu, 31 Jan 2008 11:55:05 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080131105504.GA4332@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz> <20080131102919.GC27157@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080131102919.GC27157@elte.hu>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 31 Jan 2008 11:55:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 11:29:19AM +0100, Ingo Molnar wrote:
> if you apply the current sched-fixes (rollup patch below), does it get 
> any better?

No. 

Another observation, running two instances of while true; do true; done (on
1 dual core cpu) does not break interactivity.

running make clean; make -j2 in kernel tree breaks interactivity terribly.
Looks like disk I/O activity is needed to break interactivity. 

While compiling, I have more than 1GB of RAM free. One friend of mine suggests
that kernel is swapping out binaries which causes non-interactivity. The
swaparea is clean, though. He also reports that the behavior can be seen even
in 2.6.24-rc8. 

-- 
Luká¹ Hejtmánek
