Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYBDOhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYBDOhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYBDOg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:36:59 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:33286 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYBDOg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:36:58 -0500
Date: Mon, 4 Feb 2008 15:36:22 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080204143622.GC4329@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz> <20080131102919.GC27157@elte.hu> <20080204111747.GB4450@ics.muni.cz> <1202124997.32654.78.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1202124997.32654.78.camel@lappy>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 04 Feb 2008 15:36:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 12:36:36PM +0100, Peter Zijlstra wrote:
> I can't reproduce this with a pure cpu load. I started 10 
>   while :; do :; done &
> instances and aside from slowing down, nothing bad happened.

yes, while true; do true; does nothing wrong. But running make -j2 in kernel
sources or mesa sources is catastrophic.
 
> May I suggest you try latency top to see if there is something in your
> build scenario that generates horrible latencies (some IO path or
> whatnot).

see my previous mail to Ingo (you were Cc.), latency top says that Xorg and
gnome-terminal suffers 300+ms latency in scheduler: waiting for cpu.

-- 
Luká¹ Hejtmánek
