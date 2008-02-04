Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYBDM3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYBDM3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYBDM3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:29:35 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:45448 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYBDM3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:29:34 -0500
Date: Mon, 4 Feb 2008 13:29:00 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080204122900.GA4287@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz> <20080131102919.GC27157@elte.hu> <20080204111747.GB4450@ics.muni.cz> <20080204120131.GA20962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080204120131.GA20962@elte.hu>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 04 Feb 2008 13:29:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 01:01:32PM +0100, Ingo Molnar wrote:
> 
> * Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> 
> > but in such a case, kernel 2.6.24-git13 does oops at startup in 
> > sched_slice.
> 
> could you tell me more about this oops? You booted unmodified, latest 
> -git and it oopsed in sched_slice()? The patch below should work around 
> any oopses in sched_slice(). [but this is really a 'must not happen' 
> scenario - so a just-for-testing patch]

No, I booted modified lates git to see if mentioned patch (revertin slices) 
solves horrible non-interactivy problem. With your fix, I can boot now but 
the patch did not help. Make -j2 in kernel sources significantly decreases 
interactivity. Any ideas?
 
-- 
Luká¹ Hejtmánek
