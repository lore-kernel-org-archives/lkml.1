Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYCVQTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYCVQTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYCVQTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:19:23 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:29329 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYCVQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:19:22 -0400
Date: Sat, 22 Mar 2008 17:19:18 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Lennert Buytenhek <buytenh@wantstofly.org>,
       Riku Voipio <riku.voipio@movial.fi>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 33/76] futex: runtime enable pi and robust functionality
Message-ID: <20080322161918.GA6367@osiris.boeblingen.de.ibm.com>
References: <20080321224250.144333319@sous-sol.org> <20080321224400.674465387@sous-sol.org> <alpine.LFD.1.00.0803220833040.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803220833040.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 08:37:07AM +0100, Thomas Gleixner wrote:
> On Fri, 21 Mar 2008, Chris Wright wrote:
> 
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> 
> For this one you need the S390 fixes:
> 
> 504e75d0ed3389747e40a4aaa4b1f4e569576665
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Thu Mar 20 17:33:38 2008 +0100
> 
>     [S390] futex: let futex_atomic_cmpxchg_pt survive early functional tests.

Yes, forgot to add -stable to the cc list. Sorry.

> commit d5b02b3ff1d9a2e1074f559c84ed378cfa6fc3c0
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Tue Feb 19 15:29:34 2008 +0100
> 
>     [S390] Fix futex_atomic_cmpxchg_std inline assembly.

This one is already in 2.6.24.3.
