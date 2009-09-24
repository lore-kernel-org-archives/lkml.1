Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZIXTek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZIXTek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZIXTei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:34:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZIXTeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:34:37 -0400
Date: Thu, 24 Sep 2009 21:34:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
Message-ID: <20090924193422.GB2533@elte.hu>
References: <20090924191642.GA19225@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924191642.GA19225@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> I would like to get an official ACK or NAK for this patching technique 
> from inside Intel, and preferrably from AMD as well.  If it does work 
> as described it would provide a very clean way to do one-shot 
> alternative functions, which probably would be higher value than 
> immediate data values.

Sounds tempting. Things like the CONFIG_SECURITY hookery could use it?

But ... since it's patched under stopmachine, is there any reason why 
this wouldnt work?

	Ingo
