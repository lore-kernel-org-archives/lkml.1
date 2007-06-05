Return-Path: <linux-kernel-owner+w=401wt.eu-S933743AbXFEWHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbXFEWHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764122AbXFEWH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:07:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765558AbXFEWHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:07:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/5] 2.6.22-rc4: known regressions
Date: Wed, 6 Jun 2007 00:13:11 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Rodrigo Luiz <troops.of.doom@gmail.com>
References: <4665769D.9090808@googlemail.com>
In-Reply-To: <4665769D.9090808@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706060013.12434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 June 2007 16:43, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc4.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> 
> Unclassified
> 
> Subject    : Kernel hang on CMOS_READ
> References : http://lkml.org/lkml/2007/6/3/138
> Submitter  : Rodrigo Luiz <troops.of.doom@gmail.com>
> Status     : Unknown
> 
> Subject    : kernel BUG at arch/i386/kernel/cpu/perfctr-watchdog.c:126!
> References : http://lkml.org/lkml/2007/6/3/60
> Submitter  : Udo A. Steinberg <us15@os.inf.tu-dresden.de>
> Status     : Unknown
> 
> Subject    : using smp_processor_id() in preemptible, in mtrr_save_state
> References : http://lkml.org/lkml/2007/6/3/38
> Submitter  : Rafael J. Wysocki <rjw@sisk.pl>
> Status     : Unknown

Fixed in -mm (mtrr-atomicity-fix.patch), should hit the mainline soon.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
