Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYBDRBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYBDRBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYBDRB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:01:29 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:58254 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbYBDRB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:01:28 -0500
Date: Mon, 4 Feb 2008 18:00:49 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080204170049.GA4207@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz> <20080131102919.GC27157@elte.hu> <20080204111747.GB4450@ics.muni.cz> <1202124997.32654.78.camel@lappy> <20080204143622.GC4329@ics.muni.cz> <1202136310.6890.0.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1202136310.6890.0.camel@lappy>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 04 Feb 2008 18:00:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 03:45:10PM +0100, Peter Zijlstra wrote:
> > see my previous mail to Ingo (you were Cc.), latency top says that Xorg and
> > gnome-terminal suffers 300+ms latency in scheduler: waiting for cpu.
> 
> what happens when you turn CONFIG_FAIR_GROUP_SCHED off?

If I disable CONFIG_FAIR_GROUP_SCHED, it is a lot better. I would not call it
optimal, though. 

Xorg has 20ms latency, gnome-terminal another 20ms latency. If I just press
a key (a letter for instance) to see how autorepeat fills terminal, one can
see that autorepeat is not smooth and it is stopping for a little while
(really extra short stops are visible but still visible). But  it is really 
a ton better that it was with fair group sched.

So, any conclusion? The case is closed or any further investigation should be 
done?

-- 
Luká¹ Hejtmánek
