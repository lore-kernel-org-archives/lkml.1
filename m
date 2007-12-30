Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXL3NGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXL3NGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXL3NGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:06:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbXL3NGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:06:41 -0500
Date: Sun, 30 Dec 2007 14:05:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230130544.GB16946@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230124852.GA30836@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230124852.GA30836@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > drivers that then are shown to really need it could use their *own* 
> > ports.
> 
> The i8259 driver uses it and it is known to be needed on some old 
> chipsets. But it doesn't really have any "own" ports to use afaik.

we'll solve that via an i8259-specific quirk. That is a lot cleaner and 
maintainable than the current generic, always-enabled "opt out" 
port-0x80 quirk.

	Ingo
