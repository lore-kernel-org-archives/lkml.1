Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbXLSAbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbXLSAbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbXLSAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:31:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbXLSAbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:31:41 -0500
Date: Wed, 19 Dec 2007 01:31:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: kinesis <jriley1337@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: hwclock --systohc locks machine up, RTC conflict problems
Message-ID: <20071219003131.GA16927@elte.hu>
References: <14245613.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14245613.post@talk.nabble.com>
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


* kinesis <jriley1337@yahoo.com> wrote:

> my machine is 64bit running SLAMD64 v12 (slackware) Linux excalibur 
> 2.6.24-rc4-kinesis-g94545bad #8 SMP Sun Dec 9 10:47:29 PST 2007 x86_64 
> x86_64 x86_64 GNU/Linux
> 
> Issuing the command hwclock --systohc and sometimes at boot --hctosys 
> causes my machine to freeze.

could you try the "x86: IO delay quirk" patch attached to this bugzilla:

  http://bugzilla.kernel.org/show_bug.cgi?id=6307

please boot with io_delay=0xed [or io_delay=udelay or io_delay=none].

does that fix the lockups?

	Ingo
