Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYGKKXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYGKKXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYGKKX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:23:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44637 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYGKKX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:23:28 -0400
Date: Fri, 11 Jul 2008 12:23:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Message-ID: <20080711102310.GA17033@elte.hu>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com> <20080710171721.GA19737@elte.hu> <20080710181234.GA32174@elte.hu> <20080710195249.GB17255@uranus.ravnborg.org> <20080710195425.GB23322@elte.hu> <20080711082042.GT7963@erda.amd.com> <20080711102205.GA22725@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711102205.GA22725@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > > 
> > > > So if I am not mistaken you can kill pci-y entirely:
> > 
> > Yes, but...
> > 
> > > > 
> > > > obj-y                           := fixup.o
> > 
> > ... this is with a plus:
> > 
> > obj-y                           += fixup.o
> 
> obj-y is empty when you enter the Makefile.
> So if you start out with ':=' or '+=' is no difference.

i guess it's safer to use +=, because it's ordering invariant.

We should use := only if we absolutely want to override the current 
rules.

	Ingo
