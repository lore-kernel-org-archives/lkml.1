Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYCVHpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYCVHpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 03:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYCVHpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 03:45:04 -0400
Received: from www.tglx.de ([62.245.132.106]:36925 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbYCVHpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 03:45:01 -0400
Date: Sat, 22 Mar 2008 08:37:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
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
Subject: Re: [patch 33/76] futex: runtime enable pi and robust
 functionality
In-Reply-To: <20080321224400.674465387@sous-sol.org>
Message-ID: <alpine.LFD.1.00.0803220833040.3781@apollo.tec.linutronix.de>
References: <20080321224250.144333319@sous-sol.org> <20080321224400.674465387@sous-sol.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Chris Wright wrote:

> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------

For this one you need the S390 fixes:

504e75d0ed3389747e40a4aaa4b1f4e569576665
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Thu Mar 20 17:33:38 2008 +0100

    [S390] futex: let futex_atomic_cmpxchg_pt survive early functional tests.

commit d5b02b3ff1d9a2e1074f559c84ed378cfa6fc3c0
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Tue Feb 19 15:29:34 2008 +0100

    [S390] Fix futex_atomic_cmpxchg_std inline assembly.

Thanks,

	tglx

